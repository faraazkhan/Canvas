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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe User do
  
  context "validation" do
    it "should create a new instance given valid attributes" do
      user_model
    end
  end
  
  it "should get the first email from communication_channel" do
    @user = User.create
    @cc1 = mock('CommunicationChannel')
    @cc1.stubs(:path).returns('cc1')
    @cc2 = mock('CommunicationChannel')
    @cc2.stubs(:path).returns('cc2')
    @user.stubs(:communication_channels).returns([@cc1, @cc2])
    @user.stubs(:communication_channel).returns(@cc1)
    @user.communication_channel.should eql(@cc1)
  end
  
  it "should be able to assert a name" do
    @user = User.create
    @user.assert_name(nil)
    @user.name.should eql('User')
    @user.assert_name('david')
    @user.name.should eql('david')
    @user.assert_name('bill')
    @user.name.should eql('bill')
    @user.assert_name(nil)
    @user.name.should eql('bill')
    @user = User.find(@user)
    @user.name.should eql('bill')
  end

  it "should update account associations when a course account changes" do
    account1 = account_model
    account2 = account_model
    course_with_student
    @user.associated_accounts.length.should eql(1)
    @user.associated_accounts.first.should eql(Account.default)
    
    @course.account = account1
    @course.save!
    @course.reload
    @user.reload
    
    @user.associated_accounts.length.should eql(1)
    @user.associated_accounts.first.should eql(account1)
    
    @course.account = account2
    @course.save!
    @user.reload
    
    @user.associated_accounts.length.should eql(1)
    @user.associated_accounts.first.should eql(account2)
  end
  
  it "should update account associations when a course account moves in the hierachy" do
    account1 = account_model
    
    @enrollment = course_with_student(:account => account1)
    @course.account = account1
    @course.save!
    @course.reload
    @user.reload
    
    @user.associated_accounts.length.should eql(1)
    @user.associated_accounts.first.should eql(account1)
    
    account2 = account_model
    account1.parent_account = account2
    account1.save!
    @course.reload
    @user.reload
    
    @user.associated_accounts.length.should eql(2)
    @user.associated_accounts[0].should eql(account1)
    @user.associated_accounts[1].should eql(account2)
  end
  
  it "should update account associations when a user is associated to an account just by pseudonym" do
    account1 = account_model
    account2 = account_model
    user = user_with_pseudonym

    pseudonym = user.pseudonyms.first
    pseudonym.account = account1
    pseudonym.save
    
    user.reload
    user.associated_accounts.length.should eql(1)
    user.associated_accounts.first.should eql(account1)

    # Make sure that multiple sequential updates also work
    pseudonym.account = account2
    pseudonym.save
    pseudonym.account = account1
    pseudonym.save
    user.reload
    user.associated_accounts.length.should eql(1)
    user.associated_accounts.first.should eql(account1)

    account1.parent_account = account2
    account1.save!
    
    user.reload
    user.associated_accounts.length.should eql(2)
    user.associated_accounts[0].should eql(account1)
    user.associated_accounts[1].should eql(account2)
  end

  it "should update account associations when a user is associated to an account just by account_users" do
    account = account_model
    @user = User.create
    account.add_user(@user)

    @user.reload
    @user.associated_accounts.length.should eql(1)
    @user.associated_accounts.first.should eql(account)
  end
  
  it "should populate dashboard_messages" do
    Notification.create(:name => "Assignment Created")
    course_with_teacher(:active_all => true)
    StreamItem.for_user(@user).should be_empty
    @a = @course.assignments.new(:title => "some assignment")
    @a.workflow_state = "available"
    @a.save
    StreamItem.for_user(@user).should_not be_empty
  end
  
  it "should be able to remove itself from a root account" do
    account1 = Account.create
    account2 = Account.create
    user = User.create
    user.register!
    p1 = user.pseudonyms.create(:unique_id => "user1")
    p2 = user.pseudonyms.create(:unique_id => "user2")
    p1.account = account1
    p2.account = account2
    p1.save!
    p2.save!
    account1.add_user(user)
    account2.add_user(user)
    course1 = account1.courses.create
    course2 = account2.courses.create
    course1.offer!
    course2.offer!
    enrollment1 = course1.enroll_student(user)
    enrollment2 = course2.enroll_student(user)
    enrollment1.workflow_state = 'active'
    enrollment2.workflow_state = 'active'
    enrollment1.save!
    enrollment2.save!
    user.associated_account_ids.include?(account1.id).should be_true
    user.associated_account_ids.include?(account2.id).should be_true
    user.remove_from_root_account(account2)
    user.reload
    user.associated_account_ids.include?(account1.id).should be_true
    user.associated_account_ids.include?(account2.id).should be_false
  end

  it "should search by multiple fields" do
    @account = Account.create!
    user1 = User.create! :name => "longname1", :short_name => "shortname1"
    user1.register!
    user2 = User.create! :name => "longname2", :short_name => "shortname2"
    user2.register!

    User.name_like("longname1").map(&:id).should == [user1.id]
    User.name_like("shortname2").map(&:id).should == [user2.id]
    User.name_like("sisid1").map(&:id).should == []
    User.name_like("uniqueid2").map(&:id).should == []

    p1 = user1.pseudonyms.new :unique_id => "uniqueid1", :account => @account
    p1.sis_user_id = "sisid1"
    p1.save!
    p2 = user2.pseudonyms.new :unique_id => "uniqueid2", :account => @account
    p2.sis_user_id = "sisid2"
    p2.save!

    User.name_like("longname1").map(&:id).should == [user1.id]
    User.name_like("shortname2").map(&:id).should == [user2.id]
    User.name_like("sisid1").map(&:id).should == [user1.id]
    User.name_like("uniqueid2").map(&:id).should == [user2.id]

    p3 = user1.pseudonyms.new :unique_id => "uniqueid3", :account => @account
    p3.sis_user_id = "sisid3"
    p3.save!
    
    User.name_like("longname1").map(&:id).should == [user1.id]
    User.name_like("shortname2").map(&:id).should == [user2.id]
    User.name_like("sisid1").map(&:id).should == [user1.id]
    User.name_like("uniqueid2").map(&:id).should == [user2.id]
    User.name_like("uniqueid3").map(&:id).should == [user1.id]

    p4 = user1.pseudonyms.new :unique_id => "uniqueid4", :account => @account
    p4.sis_user_id = "sisid3 2"
    p4.save!

    User.name_like("longname1").map(&:id).should == [user1.id]
    User.name_like("shortname2").map(&:id).should == [user2.id]
    User.name_like("sisid1").map(&:id).should == [user1.id]
    User.name_like("uniqueid2").map(&:id).should == [user2.id]
    User.name_like("uniqueid3").map(&:id).should == [user1.id]
    User.name_like("sisid3").map(&:id).should == [user1.id]

    user3 = User.create! :name => "longname1", :short_name => "shortname3"
    user3.register!
    
    User.name_like("longname1").map(&:id).sort.should == [user1.id, user3.id].sort
    User.name_like("shortname2").map(&:id).should == [user2.id]
    User.name_like("sisid1").map(&:id).should == [user1.id]
    User.name_like("uniqueid2").map(&:id).should == [user2.id]
    User.name_like("uniqueid3").map(&:id).should == [user1.id]
    User.name_like("sisid3").map(&:id).should == [user1.id]

    User.name_like("sisid3").map(&:id).should == [user1.id]
    User.name_like("uniqueid4").map(&:id).should == [user1.id]
    p4.destroy
    User.name_like("sisid3").map(&:id).should == [user1.id]
    User.name_like("uniqueid4").map(&:id).should == []

  end

  it "should be able to be removed from a root account with non-Canvas auth" do
    account1 = account_with_cas
    account2 = Account.create!
    user = User.create!
    user.register!
    p1 = user.pseudonyms.new :unique_id => "id1", :account => account1
    p1.sis_user_id = 'sis_id1'
    p1.save!
    user.pseudonyms.create! :unique_id => "id2", :account => account2
    lambda { p1.destroy }.should raise_error /Cannot delete system-generated pseudonyms/
    user.remove_from_root_account account1
    user.associated_root_accounts.should eql [account2]
  end

  it "should support incrementally adding to account associations" do
    user = User.create!
    user.user_account_associations.should == []

    sort_account_associations = lambda { |a, b| a.keys.first <=> b.keys.first }

    User.update_account_associations([user], :incremental => true, :precalculated_associations => {1 => 0})
    user.user_account_associations.reload.map { |aa| {aa.account_id => aa.depth} }.should == [{1 => 0}]

    User.update_account_associations([user], :incremental => true, :precalculated_associations => {2 => 1})
    user.user_account_associations.reload.map { |aa| {aa.account_id => aa.depth} }.sort(&sort_account_associations).should == [{1 => 0}, {2 => 1}].sort(&sort_account_associations)

    User.update_account_associations([user], :incremental => true, :precalculated_associations => {3 => 1, 1 => 2, 2 => 0})
    user.user_account_associations.reload.map { |aa| {aa.account_id => aa.depth} }.sort(&sort_account_associations).should == [{1 => 0}, {2 => 0}, {3 => 1}].sort(&sort_account_associations)
  end

  def create_course_with_student_and_assignment
    @course = course_model
    @course.offer!
    @student = user_model
    @course.enroll_student @student
    @assignment = @course.assignments.create :title => "Test Assignment", :points_possible => 10
  end

  it "should not include recent feedback for muted assignments" do
    create_course_with_student_and_assignment
    @assignment.mute!
    @assignment.grade_student @student, :grade => 9
    @user.recent_feedback.should be_empty
  end

  it "should include recent feedback for unmuted assignments" do
    create_course_with_student_and_assignment
    @assignment.grade_student @user, :grade => 9
    @user.recent_feedback(:contexts => [@course]).should_not be_empty
  end

  it "should return appropriate courses with primary enrollment" do
    user
    @course1 = course(:course_name => "course", :active_course => true)
    @course1.enroll_user(@user, 'StudentEnrollment', :enrollment_state => 'active')

    @course2 = course(:course_name => "other course", :active_course => true)
    @course2.enroll_user(@user, 'TeacherEnrollment', :enrollment_state => 'active')

    @course3 = course(:course_name => "yet another course", :active_course => true)
    @course3.enroll_user(@user, 'StudentEnrollment', :enrollment_state => 'active')
    @course3.enroll_user(@user, 'TeacherEnrollment', :enrollment_state => 'active')

    @course4 = course(:course_name => "not yet active")
    @course4.enroll_user(@user, 'StudentEnrollment')

    @course5 = course(:course_name => "invited")
    @course5.enroll_user(@user, 'TeacherEnrollment')

    # only four, in the right order (type, then name), and with the top type per course
    @user.courses_with_primary_enrollment.map{|c| [c.id, c.primary_enrollment]}.should eql [
      [@course5.id, 'TeacherEnrollment'],
      [@course2.id, 'TeacherEnrollment'],
      [@course3.id, 'TeacherEnrollment'],
      [@course1.id, 'StudentEnrollment']
    ]
  end

  context "move_to_user" do
    it "should delete the old user" do
      @user1 = user_model
      @user2 = user_model
      @user2.move_to_user(@user1)
      @user1.reload
      @user2.reload
      @user1.should_not be_deleted
      @user2.should be_deleted
    end
    
    it "should move pseudonyms to the new user" do
      @user1 = user_model
      @user2 = user_model
      @user2.pseudonyms.create!(:unique_id => 'sam@yahoo.com')
      @user2.move_to_user(@user1)
      @user2.reload
      @user2.pseudonyms.should be_empty
      @user1.reload
      @user1.pseudonyms.map(&:unique_id).should be_include('sam@yahoo.com')
    end
    
    it "should move submissions to the new user (but only if they don't already exist)" do
      @user1 = user_model
      @user2 = user_model
      @a1 = assignment_model
      s1 = @a1.find_or_create_submission(@user1)
      s2 = @a1.find_or_create_submission(@user2)
      @a2 = assignment_model
      s3 = @a2.find_or_create_submission(@user2)
      @user2.submissions.length.should eql(2)
      @user1.submissions.length.should eql(1)
      @user2.move_to_user(@user1)
      @user2.reload
      @user1.reload
      @user2.submissions.length.should eql(1)
      @user2.submissions.first.id.should eql(s2.id)
      @user1.submissions.length.should eql(2)
      @user1.submissions.map(&:id).should be_include(s1.id)
      @user1.submissions.map(&:id).should be_include(s3.id)
    end

    it "should move ccs to the new user (but only if they don't already exist)" do
      @user1 = user_model
      @user2 = user_model
      # unconfirmed => active conflict
      @user1.communication_channels.create!(:path => 'a@instructure.com')
      @user2.communication_channels.create!(:path => 'A@instructure.com') { |cc| cc.workflow_state = 'active' }
      # active => unconfirmed conflict
      @user1.communication_channels.create!(:path => 'b@instructure.com') { |cc| cc.workflow_state = 'active' }
      @user2.communication_channels.create!(:path => 'B@instructure.com')
      # active => active conflict
      @user1.communication_channels.create!(:path => 'c@instructure.com') { |cc| cc.workflow_state = 'active' }
      @user2.communication_channels.create!(:path => 'C@instructure.com') { |cc| cc.workflow_state = 'active' }
      # unconfirmed => unconfirmed conflict
      @user1.communication_channels.create!(:path => 'd@instructure.com')
      @user2.communication_channels.create!(:path => 'D@instructure.com')
      # retired => unconfirmed conflict
      @user1.communication_channels.create!(:path => 'e@instructure.com') { |cc| cc.workflow_state = 'retired' }
      @user2.communication_channels.create!(:path => 'E@instructure.com')
      # unconfirmed => retired conflict
      @user1.communication_channels.create!(:path => 'f@instructure.com')
      @user2.communication_channels.create!(:path => 'F@instructure.com') { |cc| cc.workflow_state = 'retired' }
      # retired => active conflict
      @user1.communication_channels.create!(:path => 'g@instructure.com') { |cc| cc.workflow_state = 'retired' }
      @user2.communication_channels.create!(:path => 'G@instructure.com') { |cc| cc.workflow_state = 'active' }
      # active => retired conflict
      @user1.communication_channels.create!(:path => 'h@instructure.com') { |cc| cc.workflow_state = 'active' }
      @user2.communication_channels.create!(:path => 'H@instructure.com') { |cc| cc.workflow_state = 'retired' }
      # retired => retired conflict
      @user1.communication_channels.create!(:path => 'i@instructure.com') { |cc| cc.workflow_state = 'retired' }
      @user2.communication_channels.create!(:path => 'I@instructure.com') { |cc| cc.workflow_state = 'retired' }
      # <nothing> => active
      @user2.communication_channels.create!(:path => 'j@instructure.com') { |cc| cc.workflow_state = 'active' }
      # active => <nothing>
      @user1.communication_channels.create!(:path => 'k@instructure.com') { |cc| cc.workflow_state = 'active' }
      # <nothing> => unconfirmed
      @user2.communication_channels.create!(:path => 'l@instructure.com')
      # unconfirmed => <nothing>
      @user1.communication_channels.create!(:path => 'm@instructure.com')
      # <nothing> => retired
      @user2.communication_channels.create!(:path => 'n@instructure.com') { |cc| cc.workflow_state = 'retired' }
      # retired => <nothing>
      @user1.communication_channels.create!(:path => 'o@instructure.com') { |cc| cc.workflow_state = 'retired' }

      @user1.move_to_user(@user2)
      @user1.reload
      @user2.reload
      @user2.communication_channels.map { |cc| [cc.path, cc.workflow_state] }.sort.should == [
          ['A@instructure.com', 'active'],
          ['B@instructure.com', 'retired'],
          ['C@instructure.com', 'active'],
          ['D@instructure.com', 'unconfirmed'],
          ['E@instructure.com', 'unconfirmed'],
          ['F@instructure.com', 'retired'],
          ['G@instructure.com', 'active'],
          ['H@instructure.com', 'retired'],
          ['I@instructure.com', 'retired'],
          ['a@instructure.com', 'retired'],
          ['b@instructure.com', 'active'],
          ['c@instructure.com', 'retired'],
          ['d@instructure.com', 'retired'],
          ['e@instructure.com', 'retired'],
          ['f@instructure.com', 'unconfirmed'],
          ['g@instructure.com', 'retired'],
          ['h@instructure.com', 'active'],
          ['i@instructure.com', 'retired'],
          ['j@instructure.com', 'active'],
          ['k@instructure.com', 'active'],
          ['l@instructure.com', 'unconfirmed'],
          ['m@instructure.com', 'unconfirmed'],
          ['n@instructure.com', 'retired'],
          ['o@instructure.com', 'retired']
      ]
      @user1.communication_channels.should be_empty
    end

    it "should move and uniquify enrollments" do
      @user1 = user_model
      @user2 = user_model
      course(:active_all => 1)
      @enrollment1 = @course.enroll_user(@user1)
      @enrollment2 = @course.enroll_user(@user2, 'StudentEnrollment', :enrollment_state => 'active')
      @enrollment3 = StudentEnrollment.create!(:course => @course, :course_section => @course.course_sections.create!, :user => @user1)
      @enrollment4 = @course.enroll_teacher(@user1)

      @user1.move_to_user(@user2)
      @enrollment1.reload
      @enrollment1.user.should == @user2
      @enrollment1.should be_deleted
      @enrollment2.reload
      @enrollment2.should be_active
      @enrollment2.user.should == @user2
      @enrollment3.reload
      @enrollment3.should be_invited
      @enrollment4.reload
      @enrollment4.user.should == @user2
      @enrollment4.should be_invited

      @user1.reload
      @user1.enrollments.should be_empty
    end

    it "should update account associations" do
      @account1 = account_model
      @account2 = account_model
      @pseudo1 = (@user1 = user_with_pseudonym :account => @account1).pseudonym
      @pseudo2 = (@user2 = user_with_pseudonym :account => @account2).pseudonym
      @subsubaccount1 = (@subaccount1 = @account1.sub_accounts.create!).sub_accounts.create!
      @subsubaccount2 = (@subaccount2 = @account2.sub_accounts.create!).sub_accounts.create!
      course_with_student(:account => @subsubaccount1, :user => @user1)
      course_with_student(:account => @subsubaccount2, :user => @user2)

      @user1.associated_accounts.map(&:id).sort.should == [@account1, @subaccount1, @subsubaccount1].map(&:id).sort
      @user2.associated_accounts.map(&:id).sort.should == [@account2, @subaccount2, @subsubaccount2].map(&:id).sort

      @pseudo1.user.should == @user1
      @pseudo2.user.should == @user2

      @user1.move_to_user @user2

      @pseudo1, @pseudo2 = [@pseudo1, @pseudo2].map{|p| Pseudonym.find(p.id)}
      @user1, @user2 = [@user1, @user2].map{|u| User.find(u.id)}

      @pseudo1.user.should == @pseudo2.user
      @pseudo1.user.should == @user2

      @user1.associated_accounts.map(&:id).sort.should == []
      @user2.associated_accounts.map(&:id).sort.should == [@account1, @account2, @subaccount1, @subaccount2, @subsubaccount1, @subsubaccount2].map(&:id).sort
    end
  end

  context "permissions" do
    it "should grant become_user to self" do
      @user = user_with_pseudonym(:username => 'nobody1@example.com')
      @user.grants_right?(@user, nil, :become_user).should be_true
    end

    it "should not grant become_user to other users" do
      @user1 = user_with_pseudonym(:username => 'nobody1@example.com')
      @user2 = user_with_pseudonym(:username => 'nobody2@example.com')
      @user1.grants_right?(@user2, nil, :become_user).should be_false
      @user2.grants_right?(@user1, nil, :become_user).should be_false
    end

    it "should grant become_user to site and account admins" do
      user = user_with_pseudonym(:username => 'nobody1@example.com')
      @admin = user_with_pseudonym(:username => 'nobody2@example.com')
      @site_admin = user_with_pseudonym(:username => 'nobody3@example.com')
      Account.site_admin.add_user(@site_admin)
      Account.default.add_user(@admin)
      user.grants_right?(@site_admin, nil, :become_user).should be_true
      @admin.grants_right?(@site_admin, nil, :become_user).should be_true
      user.grants_right?(@admin, nil, :become_user).should be_true
      @admin.grants_right?(@admin, nil, :become_user).should be_true
      @admin.grants_right?(user, nil, :become_user).should be_false
      @site_admin.grants_right?(@site_admin, nil, :become_user).should be_true
      @site_admin.grants_right?(user, nil, :become_user).should be_false
      @site_admin.grants_right?(@admin, nil, :become_user).should be_false
    end

    it "should not grant become_user to other site admins" do
      @site_admin1 = user_with_pseudonym(:username => 'nobody1@example.com')
      @site_admin2 = user_with_pseudonym(:username => 'nobody2@example.com')
      Account.site_admin.add_user(@site_admin1)
      Account.site_admin.add_user(@site_admin2)
      @site_admin1.grants_right?(@site_admin2, nil, :become_user).should be_false
      @site_admin2.grants_right?(@site_admin1, nil, :become_user).should be_false
    end

    it "should not grant become_user to other account admins" do
      @admin1 = user_with_pseudonym(:username => 'nobody1@example.com')
      @admin2 = user_with_pseudonym(:username => 'nobody2@example.com')
      Account.default.add_user(@admin1)
      Account.default.add_user(@admin2)
      @admin1.grants_right?(@admin2, nil, :become_user).should be_false
      @admin2.grants_right?(@admin1, nil, :become_user).should be_false
    end

    it "should not allow account admin to modify admin privileges of other account admins" do
      RoleOverride.readonly_for(Account.default, :manage_role_overrides, 'AccountAdmin').should be_true
      RoleOverride.readonly_for(Account.default, :manage_account_memberships, 'AccountAdmin').should be_true
      RoleOverride.readonly_for(Account.default, :manage_account_settings, 'AccountAdmin').should be_true
    end

    it "should grant become_user for users in multiple accounts to site admins but not account admins" do
      user = user_with_pseudonym(:username => 'nobody1@example.com')
      @account2 = Account.create!
      user.pseudonyms.create!(:unique_id => 'nobodyelse@example.com', :account => @account2)
      @admin = user_with_pseudonym(:username => 'nobody2@example.com')
      @site_admin = user_with_pseudonym(:username => 'nobody3@example.com')
      Account.default.add_user(@admin)
      Account.site_admin.add_user(@site_admin)
      user.grants_right?(@admin, nil, :become_user).should be_false
      user.grants_right?(@site_admin, nil, :become_user).should be_true
      @account2.add_user(@admin)
      user.grants_right?(@admin, nil, :become_user).should be_false
      user.grants_right?(@site_admin, nil, :become_user).should be_true
    end

    it "should not grant become_user for dis-associated users" do
      @user1 = user_model
      @user2 = user_model
      @user1.grants_right?(@user2, nil, :become_user).should be_false
      @user2.grants_right?(@user1, nil, :become_user).should be_false
    end

    it "should grant become_user for dis-associated users to site admins" do
      user = user_model
      @site_admin = user_model
      Account.site_admin.add_user(@site_admin)
      user.grants_right?(@site_admin, nil, :become_user).should be_true
      @site_admin.grants_right?(user, nil, :become_user).should be_false
    end
  end

  context "messageable_users" do
    before(:each) do
      @admin = user_model
      @student = user_model
      tie_user_to_account(@admin, :membership_type => 'AccountAdmin')
      tie_user_to_account(@student, :membership_type => 'Student')
    end

    def set_up_course_with_users
      @course = course_model(:name => 'the course')
      @this_section_teacher = @teacher
      @course.offer!

      @this_section_user = user_model
      @course.enroll_user(@this_section_user, 'StudentEnrollment', :enrollment_state => 'active')

      @other_section_user = user_model
      @other_section = @course.course_sections.create
      @course.enroll_user(@other_section_user, 'StudentEnrollment', :enrollment_state => 'active', :section => @other_section)
      @other_section_teacher = user_model
      @course.enroll_user(@other_section_teacher, 'TeacherEnrollment', :enrollment_state => 'active', :section => @other_section)

      @group = @course.groups.create(:name => 'the group')
      @group.users = [@this_section_user]

      @unrelated_user = user_model
    end

    it "should only return users from the specified context and type" do
      set_up_course_with_users
      @course.enroll_user(@student, 'StudentEnrollment', :enrollment_state => 'active')

      @student.messageable_users(:context => "course_#{@course.id}").map(&:id).sort.
        should eql [@student, @this_section_user, @this_section_teacher, @other_section_user, @other_section_teacher].map(&:id).sort

      @student.messageable_users(:context => "course_#{@course.id}_students").map(&:id).sort.
        should eql [@student, @this_section_user, @other_section_user].map(&:id).sort

      @student.messageable_users(:context => "group_#{@group.id}").map(&:id).sort.
        should eql [@this_section_user].map(&:id).sort

      @student.messageable_users(:context => "section_#{@other_section.id}").map(&:id).sort.
        should eql [@other_section_user, @other_section_teacher].map(&:id).sort

      @student.messageable_users(:context => "section_#{@other_section.id}_teachers").map(&:id).sort.
        should eql [@other_section_teacher].map(&:id).sort
    end

    it "should not include users from other sections if visibility is limited to sections" do
      set_up_course_with_users
      @course.enroll_user(@student, 'StudentEnrollment', :enrollment_state => 'active', :limit_priveleges_to_course_section => true)
      messageable_users = @student.messageable_users.map(&:id)
      messageable_users.should include @this_section_user.id
      messageable_users.should_not include @other_section_user.id

      messageable_users = @student.messageable_users(:context => "course_#{@course.id}").map(&:id)
      messageable_users.should include @this_section_user.id
      messageable_users.should_not include @other_section_user.id

      messageable_users = @student.messageable_users(:context => "section_#{@other_section.id}").map(&:id)
      messageable_users.should be_empty
    end

    it "should only include users from the specified section" do
      set_up_course_with_users
      @course.enroll_user(@student, 'StudentEnrollment', :enrollment_state => 'active')
      messageable_users = @student.messageable_users(:context => "section_#{@course.default_section.id}").map(&:id)
      messageable_users.should include @this_section_user.id
      messageable_users.should_not include @other_section_user.id

      messageable_users = @student.messageable_users(:context => "section_#{@other_section.id}").map(&:id)
      messageable_users.should_not include @this_section_user.id
      messageable_users.should include @other_section_user.id
    end

    it "should include users from all sections if visibility is not limited to sections" do
      set_up_course_with_users
      @course.enroll_user(@student, 'StudentEnrollment', :enrollment_state => 'active')
      messageable_users = @student.messageable_users.map(&:id)
      messageable_users.should include @this_section_user.id
      messageable_users.should include @other_section_user.id
    end

    it "should return users for a specified group if the receiver can access the group" do
      set_up_course_with_users
      @course.enroll_user(@student, 'StudentEnrollment', :enrollment_state => 'active')

      @this_section_user.messageable_users(:context => "group_#{@group.id}").map(&:id).should eql [@this_section_user.id]
      # student can see it too, even though he's not in the group (since he can view the roster)
      @student.messageable_users(:context => "group_#{@group.id}").map(&:id).should eql [@this_section_user.id]
    end

    it "should respect section visibility when returning users for a specified group" do
      set_up_course_with_users
      @course.enroll_user(@student, 'StudentEnrollment', :enrollment_state => 'active', :limit_priveleges_to_course_section => true)

      @group.users << @other_section_user

      @this_section_user.messageable_users(:context => "group_#{@group.id}").map(&:id).sort.should eql [@this_section_user.id, @other_section_user.id]
      @this_section_user.group_membership_visibility[:user_counts][@group.id].should eql 2
      # student can only see people in his section
      @student.messageable_users(:context => "group_#{@group.id}").map(&:id).should eql [@this_section_user.id]
      @student.group_membership_visibility[:user_counts][@group.id].should eql 1
    end

    it "should only show admins and the observed if the receiver is an observer" do
      set_up_course_with_users
      @course.enroll_user(@admin, 'TeacherEnrollment', :enrollment_state => 'active')
      @course.enroll_user(@student, 'StudentEnrollment', :enrollment_state => 'active')

      observer = user_model

      enrollment = @course.enroll_user(observer, 'ObserverEnrollment', :enrollment_state => 'active')
      enrollment.associated_user_id = @student.id
      enrollment.save

      messageable_users = observer.messageable_users.map(&:id)
      messageable_users.should include @admin.id
      messageable_users.should include @student.id
      messageable_users.should_not include @this_section_user.id
      messageable_users.should_not include @other_section_user.id
    end

    it "should include all shared contexts and enrollment information" do
      set_up_course_with_users
      @first_course = @course
      @first_course.enroll_user(@this_section_user, 'TaEnrollment', :enrollment_state => 'active')
      @first_course.enroll_user(@admin, 'TeacherEnrollment', :enrollment_state => 'active')

      @other_course = course_model
      @other_course.offer!
      @other_course.enroll_user(@admin, 'TeacherEnrollment', :enrollment_state => 'active')
      # other_section_user is a teacher in one course, student in another
      @other_course.enroll_user(@other_section_user, 'TeacherEnrollment', :enrollment_state => 'active')

      messageable_users = @admin.messageable_users
      this_section_user = messageable_users.detect{|u| u.id == @this_section_user.id}
      this_section_user.common_courses.keys.should include @first_course.id
      this_section_user.common_courses[@first_course.id].sort.should eql ['StudentEnrollment', 'TaEnrollment']

      two_context_guy = messageable_users.detect{|u| u.id == @other_section_user.id}
      two_context_guy.common_courses.keys.should include @first_course.id
      two_context_guy.common_courses[@first_course.id].sort.should eql ['StudentEnrollment']
      two_context_guy.common_courses.keys.should include @other_course.id
      two_context_guy.common_courses[@other_course.id].sort.should eql ['TeacherEnrollment']
    end

    it "should include users with no shared contexts iff admin" do
      @admin.messageable_users(:ids => [@student.id]).should_not be_empty
      @student.messageable_users(:ids => [@admin.id]).should be_empty
    end

    it "should not do admin catch-all if specific contexts requested" do
      course1 = course_model
      course2 = course_model
      course2.offer!

      enrollment = course2.enroll_teacher(@admin)
      enrollment.workflow_state = 'active'
      enrollment.save
      @admin.reload

      enrollment = course2.enroll_student(@student)
      enrollment.workflow_state = 'active'
      enrollment.save

      @admin.messageable_users(:context => "course_#{course1.id}", :ids => [@student.id]).should be_empty
      @admin.messageable_users(:context => "course_#{course2.id}", :ids => [@student.id]).should_not be_empty
      @student.messageable_users(:context => "course_#{course2.id}", :ids => [@admin.id]).should_not be_empty
    end

    it "should return names with shared contexts" do
      set_up_course_with_users
      @course.enroll_user(@student, 'StudentEnrollment', :enrollment_state => 'active')
      @group.users << @student

      @student.shared_contexts(@this_section_user).should eql ['the course', 'the group']
      @student.short_name_with_shared_contexts(@this_section_user).should eql "#{@this_section_user.short_name} (the course and the group)"

      @student.shared_contexts(@other_section_user).should eql ['the course']
      @student.short_name_with_shared_contexts(@other_section_user).should eql "#{@other_section_user.short_name} (the course)"

      @student.shared_contexts(@unrelated_user).should eql []
      @student.short_name_with_shared_contexts(@unrelated_user).should eql @unrelated_user.short_name
    end
  end
  
  context "lti_role_types" do
    it "should return the correct role types" do
      course_model
      @course.offer
      teacher = user_model
      student = user_model
      nobody = user_model
      admin = user_model
      @course.root_account.add_user(admin)
      @course.enroll_teacher(teacher).accept
      @course.enroll_student(student).accept
      teacher.lti_role_types(@course).should == ['Instructor']
      student.lti_role_types(@course).should == ['Learner']
      nobody.lti_role_types(@course).should == ['urn:lti:sysrole:ims/lis/None']
      admin.lti_role_types(@course).should == ['urn:lti:instrole:ims/lis/Administrator']
    end
    
    it "should return multiple role types if applicable" do
      course_model
      @course.offer
      teacher = user_model
      @course.root_account.add_user(teacher)
      @course.enroll_teacher(teacher).accept
      @course.enroll_student(teacher).accept
      teacher.lti_role_types(@course).sort.should == ['Instructor','Learner','urn:lti:instrole:ims/lis/Administrator'].sort
    end
    
    it "should not return role types from other contexts" do
      @course1 = course_model
      @course2 = course_model
      @course.offer
      teacher = user_model
      student = user_model
      @course1.enroll_teacher(teacher).accept
      @course1.enroll_student(student).accept
      teacher.lti_role_types(@course2).should == ['urn:lti:sysrole:ims/lis/None']
      student.lti_role_types(@course2).should == ['urn:lti:sysrole:ims/lis/None']
    end
  end
  
  context "tabs_available" do
    it "should not include unconfigured external tools" do
      tool = Account.default.context_external_tools.new(:consumer_key => 'bob', :shared_secret => 'bob', :name => 'bob')
      tool.settings[:course_navigation] = {:url => "http://www.example.com", :text => "Example URL"}
      tool.save!
      tool.has_user_navigation.should == false
      user_model
      tabs = UserProfile.new(@user).tabs_available(@user, :root_account => Account.default)
      tabs.map{|t| t[:id] }.should_not be_include(tool.asset_string)
    end
    
    it "should include configured external tools" do
      tool = Account.default.context_external_tools.new(:consumer_key => 'bob', :shared_secret => 'bob', :name => 'bob')
      tool.settings[:user_navigation] = {:url => "http://www.example.com", :text => "Example URL"}
      tool.save!
      tool.has_user_navigation.should == true
      user_model
      tabs = UserProfile.new(@user).tabs_available(@user, :root_account => Account.default)
      tabs.map{|t| t[:id] }.should be_include(tool.asset_string)
      tab = tabs.detect{|t| t[:id] == tool.asset_string }
      tab[:href].should == :user_external_tool_path
      tab[:args].should == [@user.id, tool.id]
      tab[:label].should == "Example URL"
    end
  end
  
  context "avatars" do
    it "should find only users with avatars set" do
      user_model
      @user.avatar_state = 'submitted'
      @user.save!
      User.with_avatar_state('submitted').count.should == 0
      User.with_avatar_state('any').count.should == 0
      @user.avatar_image_url = 'http://www.example.com'
      @user.save!
      User.with_avatar_state('submitted').count.should == 1
      User.with_avatar_state('any').count.should == 1
    end

    it "should clear avatar state when assigning by service that no longer exists" do
      user_model
      @user.avatar_image_url = 'http://www.example.com'
      @user.avatar_image = { 'type' => 'twitter' }
      @user.avatar_image_url.should be_nil
    end
  end

  it "should find section for course" do
    course_with_student
    @student.section_for_course(@course).should == @course.default_section
  end

  describe "name_parts" do
    it "should infer name parts" do
      User.name_parts('Cody Cutrer').should == ['Cody', 'Cutrer', nil]
      User.name_parts('  Cody  Cutrer   ').should == ['Cody', 'Cutrer', nil]
      User.name_parts('Cutrer, Cody').should == ['Cody', 'Cutrer', nil]
      User.name_parts('Cutrer, Cody Houston').should == ['Cody Houston', 'Cutrer', nil]
      User.name_parts('St. Clair, John').should == ['John', 'St. Clair', nil]
      # sorry, can't figure this out
      User.name_parts('John St. Clair').should == ['John St.', 'Clair', nil]
      User.name_parts('Jefferson Thomas Cutrer IV').should == ['Jefferson Thomas', 'Cutrer', 'IV']
      User.name_parts('Jefferson Thomas Cutrer, IV').should == ['Jefferson Thomas', 'Cutrer', 'IV']
      User.name_parts('Cutrer, Jefferson, IV').should == ['Jefferson', 'Cutrer', 'IV']
      User.name_parts('Cutrer, Jefferson IV').should == ['Jefferson', 'Cutrer', 'IV']
      User.name_parts(nil).should == [nil, nil, nil]
      User.name_parts('Bob').should == ['Bob', nil, nil]
      User.name_parts('Ho, Chi, Min').should == ['Chi Min', 'Ho', nil]
      # sorry, don't understand cultures that put the surname first
      # they should just manually specify their sort name
      User.name_parts('Ho Chi Min').should == ['Ho Chi', 'Min', nil]
      User.name_parts('').should == [nil, nil, nil]
      User.name_parts('John Doe').should == ['John', 'Doe', nil]
      User.name_parts('Junior').should == ['Junior', nil, nil]
      User.name_parts('John St. Clair', 'St. Clair').should == ['John', 'St. Clair', nil]
      User.name_parts('John St. Clair', 'Cutrer').should == ['John St.', 'Clair', nil]
      User.name_parts('St. Clair', 'St. Clair').should == [nil, 'St. Clair', nil]
      User.name_parts('St. Clair,').should == [nil, 'St. Clair', nil]
    end

    it "should keep the sortable_name up to date if all that changed is the name" do
      u = User.new
      u.name = 'Cody Cutrer'
      u.save!
      u.sortable_name.should == 'Cutrer, Cody'

      u.name = 'Bracken Mosbacker'
      u.save!
      u.sortable_name.should == 'Mosbacker, Bracken'

      u.name = 'John St. Clair'
      u.sortable_name = 'St. Clair, John'
      u.save!
      u.sortable_name.should == 'St. Clair, John'

      u.name = 'Matthew St. Clair'
      u.save!
      u.sortable_name.should == "St. Clair, Matthew"

      u.name = 'St. Clair'
      u.save!
      u.sortable_name.should == "St. Clair,"
    end
  end

  context "group_member_json" do
    before :each do
      @account = Account.default
      @enrollment = course_with_student(:active_all => true)
      @section = @enrollment.course_section
      @student.sortable_name = 'Doe, John'
      @student.short_name = 'Johnny'
      @student.save
    end

    it "should include user_id, name, and display_name" do
      @student.group_member_json(@account).should == {
        :user_id => @student.id,
        :name => 'Doe, John',
        :display_name => 'Johnny'
      }
    end

    it "should include course section (section_id and section_code) if appropriate" do
      @student.group_member_json(@account).should == {
        :user_id => @student.id,
        :name => 'Doe, John',
        :display_name => 'Johnny'
      }

      @student.group_member_json(@course).should == {
        :user_id => @student.id,
        :name => 'Doe, John',
        :display_name => 'Johnny',
        :section_id => @section.id,
        :section_code => @section.section_code
      }
    end
  end
end
