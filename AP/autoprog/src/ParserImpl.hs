-- Put your Parser implementation in this file
module ParserImpl where

import Defs
-- import either ReadP or Parsec, as relevant
import Text.Parsec
import Data.Char

-- Parsec Parser
type Parser a = Parsec String () a

----- helper functions -----
keywords :: [String]
keywords = ["type", "newtype", "data"]

-- If try is neccesary, then between might be shorter.
comments :: Parser ()
comments = skipMany $ lexeme $ string "{-" >> (manyTill anyChar (string "-}")) >> return ()
-- between (symbol "{-") (symbol "-}") (many $ noneOf "-}") >> return ()

----- parser functions -----
lexeme :: Parser a -> Parser a
lexeme p = do a <- p
              spaces
              comments
              return a

symbol :: String -> Parser ()
symbol s = lexeme $ string s >> return ()

-- Caller needs to check whether the parsed string is UPPER- or lowercase
pIdent :: Parser TVName
pIdent = lexeme $
  do c <- choice[lower,upper]
     cs <- many (alphaNum <|> satisfy (== '\'') <|> satisfy (== '_'))
     if (c:cs) `notElem` keywords then return $ c:cs
       else fail "Identifier may not be a reserved keyword."

pTypeX :: Parser PType
pTypeX = do t1 <- pType; choice [
              do symbol "->"; t2 <- pTypeX; return $ PTApp "(->)" [t1, t2],
              return t1
              ]

pType :: Parser PType
pType = choice [
  do tn <- pIdent; if isLower $ head tn then return $ PTVar tn
                   else (do ptz <- many pTypeZ; return $ PTApp tn ptz),
  do between (symbol "(") (symbol ")") $ try (do t1 <- pTypeX; symbol ","; t2 <- pTypeX; return (PTApp "(,)" [t1, t2])) <|> pTypeX-- I'd rather not use "try", also it would be smart to just parse the first pTypeX only once.
  ]

-- -- Used as a naive way to ensure tight grouping of type-constructor applications.
-- -- E.g. F G x -> (PTApp "F" [(PTApp "G" []),PTVar "x"]).
pTypeZ :: Parser PType
pTypeZ = choice [
  do tn <- pIdent; if isLower $ head tn then return $ PTVar tn
                   else (return $ PTApp tn []),
  pTypeX
  ]

----- main functions -----
parseStringType :: String -> EM PType
parseStringType s = case parse(do spaces; comments; a <- pTypeX; eof; return a) "" s of
                      Left err -> Left $ show err
                      Right a -> Right a


-- Hard?
parseStringTDeclz :: String -> EM [TDecl]
parseStringTDeclz = undefined
