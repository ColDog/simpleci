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
    object.build_for_minion
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
    object.repo_for_minion
  end

end
