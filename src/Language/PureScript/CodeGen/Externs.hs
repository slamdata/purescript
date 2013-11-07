-----------------------------------------------------------------------------
--
-- Module      :  Language.PureScript.CodeGen.Externs
-- Copyright   :  (c) Phil Freeman 2013
-- License     :  MIT
--
-- Maintainer  :  Phil Freeman <paf31@cantab.net>
-- Stability   :  experimental
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------

module Language.PureScript.CodeGen.Externs (
    externToPs
) where

import Data.List (intercalate)
import qualified Data.Map as M
import Language.PureScript.Declarations
import Language.PureScript.TypeChecker.Monad
import Language.PureScript.Pretty

externToPs :: Environment -> Declaration -> Maybe String
externToPs env (ValueDeclaration name _) = do
  (ty, _) <- M.lookup name $ names env
  return $ "foreign import " ++ show name ++ " :: " ++ prettyPrintPolyType ty
externToPs env (ExternMemberDeclaration member name ty) =
  return $ "foreign import member " ++ show member ++ " " ++ show name ++ " :: " ++ prettyPrintPolyType ty
externToPs env (ExternDataDeclaration name kind) =
  return $ "foreign import data " ++ name ++ " :: " ++ prettyPrintKind kind
externToPs env (TypeSynonymDeclaration name args ty) =
  return $ "type " ++ name ++ " " ++ unwords args ++ " = " ++ prettyPrintType ty
externToPs _ _ = Nothing
