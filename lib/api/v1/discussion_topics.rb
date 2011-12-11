#
# Copyright (C) 2011 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

module Api::V1::DiscussionTopics
  def discussion_topic_api_json(topics, context)
    topics.map do |topic|

      attachments = []
      if topic.attachment
        attachments << attachment_json(topic.attachment)
      end

      url = nil
      if topic.podcast_enabled
        code = @context_enrollment ? @context_enrollment.feed_code : @context.feed_code
        url = feeds_topic_format_path(topic.id, code, :rss)
      end

      children = topic.child_topics.scoped(:select => 'id').map(&:id)

      topic.as_json(:include_root => false,
                    :only => %w(id title assignment_id delayed_post_at last_reply_at posted_at require_initial_post root_topic_id),
                    :methods => [:user_name, :discussion_subentry_count],
                    :permissions => {:user => @current_user, :session => session}
      ).tap do |json|
        json[:message] = api_user_content(topic.message, context)
        json.merge! :podcast_url => url,
                    :topic_children => children,
                    :attachments => attachments
      end
    end
  end

  def discussion_entry_api_json(entries, context)
    entries.map do |entry|
      json = entry.as_json(:include_root => false,
                           :only => %w(id user_id created_at),
                           :methods => [:user_name, :discussion_subentry_count],
                           :permissions => {:user => @current_user, :session => session})
      json[:message] = api_user_content(entry.message, context)
      if entry.parent_id.zero?
        replies = entry.unordered_discussion_subentries.active.newest_first.find(:all, :limit => 11).to_a
        unless replies.empty?
          json[:recent_replies] = discussion_entry_api_json(replies.first(10), context)
          json[:has_more_replies] = replies.size > 10
        end
        json[:attachment] = attachment_json(entry.attachment) if entry.attachment
      end
      json
    end
  end

  def topic_pagination_path
    if @context.is_a? Course
      api_v1_course_discussion_topics_path(@context)
    else
      api_v1_group_discussion_topics_path(@context)
    end
  end

  def entry_pagination_path(topic)
    if @context.is_a? Course
      api_v1_course_discussion_entries_path(@context)
    else
      api_v1_group_discussion_entries_path(@context)
    end
  end

  def reply_pagination_path(entry)
    if @context.is_a? Course
      api_v1_course_discussion_replies_path(@context)
    else
      api_v1_group_discussion_replies_path(@context)
    end
  end
end
