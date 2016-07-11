class JobMinionSerializer < ActiveModel::Serializer
  attributes :id, :key, :build, :repo

  # The golang struct this must serialize into
  # type Build struct  {
  #   Env 		    []string	`json:"env"`
  #   BaseImage	  string		`json:"base_image"`
  #   PreTest		  []string	`json:"pre_test"`
  #   Test 		    []string	`json:"test"`
  #   PostTest 	  []string	`json:"post_test"`
  #   OnSuccess	  []string	`json:"on_success"`
  #   OnFailure 	[]string	`json:"on_failure"`
  # }
  def build
    {
        env: object.build['env'].map { |k, v| "#{k.to_s.upcase}=#{v}" },
        base_image: object.build['base_image'],
        pre_test: object.build['pre_test'],
        test: object.build['test'],
        post_test: object.build['post_test'],
        on_success: object.build['on_success'],
        on_failure: object.build['on_failure'],
    }
  end

  # The golang struct this must serialize into
  # type Repo struct {
  #   AuthUser 	    string		`json:"auth_user"`
  #   AuthPass	    string		`json:"auth_pass"`
  #   Provider 	    string		`json:"provider"`
  #   Branch 		    string		`json:"branch"`
  #   Organization	string		`json:"org"`
  #   Project 	    string		`json:"project"`
  # }
  def repo
    {
        auth_user: object.auth_username,
        auth_pass: object.auth_token,
        provider: object.repo.provider,
        branch: object.branch,
        org: object.repo.owner,
        project: object.repo.name,
    }
  end

end
