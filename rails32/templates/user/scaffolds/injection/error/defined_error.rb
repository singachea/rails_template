module Injection::Error::DefinedError
  
  class ExpectedErrorAndDoNothing < StandardError
  end

  class AlreadyLoginError < StandardError
  end
  
  class LoginRequired < StandardError
  end

  class WrongSection < StandardError
  end
  
  class TemporalCheating < StandardError
  end
  
  class UnauthorizedError < StandardError
  end
  
  class RecordNotFoundError < StandardError
  end

  class EntityNotFound < StandardError
  end

  
end