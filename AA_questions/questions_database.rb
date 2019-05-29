require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database 
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :id, :fname, :lname

  def initialize(user)
    @id = user['id']
    @fname = user['fname']
    @lname = user['lname']
  end

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        users
      WHERE 
        id = ?;
    SQL
    return nil unless user.length > 0

    User.new(user.first)
  end
  
  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM 
        users
      WHERE 
        fname = ? AND lname = ?;
    SQL
    return nil unless user.length > 0

    User.new(user.first)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end
end

class Question
  attr_accessor :id, :title, :body, :user_id

  def initialize(question)
    @id = question['id']
    @title = question['title']
    @body = question['body']
    @user_id = question['user_id']
  end
  
  def self.find_by_author_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        questions
      WHERE 
        user_id = ?;
    SQL
    return nil unless questions.length > 0
    questions.map { |question| Question.new(question) }
  end

  def author
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        user_id
      FROM
        questions
      WHERE 
        id = ?;
    SQL
    return nil unless question.length > 0

    question.first
  end

  def replies
    Reply.find_by_question_id(@id)
  end
end

class Reply
  attr_accessor :id, :body, :questions_id,  :user_id,  :reply_id

  def initialize(question)
    @id = question['id']
    @body = question['body']
    @questions_id = question['questions_id']
    @user_id = question['user_id']
    @reply_id = question['reply_id']
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        replies
      WHERE 
        user_id = ?;
    SQL
    return nil unless replies.length > 0
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(questions_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, questions_id)
      SELECT
        *
      FROM 
        replies
      WHERE 
        questions_id = ?;
    SQL
    return nil unless replies.length > 0
    replies.map { |reply| Reply.new(reply) }
  end

  def author
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        user_id
      FROM
        questions
      WHERE 
        id = ?;
    SQL
    return nil unless question.length > 0

    question.first
  end
end

# p User.find_by_id(1)
# p User.find_by_name("first","last")
# p User.find_by_name("Greg","Wathen")
# p User.find_by_name("Greg","Waffle")
# p Question.find_by_author_id(1)
# question = Question.new({"id"=>3, "title"=>"Question 2", "body"=>"Second", "user_id"=>1})
# p question.author
# p Reply.find_by_user_id(3)
# p Reply.find_by_question_id(1)

user = User.new({'id'=>4, 'fname'=>"onur", 'lname' => "eker"})
p user.authored_questions

# Question.find_by_author_id(1)
