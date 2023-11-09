-- Put your Resolver implementation in this file
module ResolverImpl where

import Defs
resolve :: TCEnv -> (TVName -> EM SType) -> PType -> EM SType
resolve tce tve pt = case pt of
  PTVar tv -> tve tv
  PTApp tc pts -> case lookup tc tce of
    Just ts -> case sequence (map (resolve tce tve) pts) of
      Right sts -> ts sts-- Does this hold for all cases? What if everything succeeds except one element, does sequence then return Left? Isn't it supposed to return Left then? <----test!
      Left err -> Left err
    Nothing -> Left "Faulty type constructer environemnt."

declare :: [TDecl] -> EM TCEnv
declare [] = Right tce0
