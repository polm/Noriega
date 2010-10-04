import Control.Monad.Instances
import Data.List
import Data.Char
import Data.Maybe
import Text.Printf
import System.Environment
import qualified Data.Map as M
import System.Exit
import qualified System.IO.Strict as S
import System (getArgs)

data Stats = Stats Int Int Int Int Int -- HT H~T ~HT ~H~T occ.

instance Show Stats where
	show (Stats a b c d e)  = show a ++ "\t" ++
				  show b ++ "\t" ++ 
				  show c ++ "\t" ++ 
				  show d ++ "\t" ++ 
				  show e  

type WordMap = M.Map String Stats

-- First, two helpers
io f = interact (unlines . f . lines)
  
--showln  = (++ "\n") . show

-- Take in a list of words, put them in the map
-- NOTE: This should not be used.
initMap :: [String] -> WordMap
initMap s = M.fromList $ 
		map (\x -> (x, Stats 0 0 0 0 0)) s

--Gets word occurences.
wordocc :: [String] -> String -> Int
wordocc d w = length $ filter (\x -> x == w) (words $ unlines d)

--Takes in list of files.
doAll :: [String] -> WordMap -> WordMap
doAll [] m = m
doAll (file : morefiles) m = doAll morefiles (doFile file m)

--cleans input
clean :: String -> String
clean s = filter (\x -> not $ elem x ":,;&*$" ) s

-- String is the file contents
doFile :: String -> WordMap -> WordMap
doFile s m = let history = words $ head $ lines $ clean s
		 test = words $ unlines $ tail $ lines $ clean s 
		 in updateMap history test (nub $ words $ clean s) m

--Hist, Test, words, map; outputs map
updateMap :: [String] -> [String] -> [String] -> WordMap -> WordMap
updateMap _ _ [] m = m
updateMap h t (w:wl) m = let ws = M.lookup w m
		    	    in case ws of
				Nothing -> updateMap h t wl (M.insert w (newStats w (Stats 0 0 0 0 0) h t) m)
				_ -> updateMap h t wl (M.insert w (newStats w (fromJust ws) h t) m)


--Take in the word, its stats, hist, test, and give new stats
newStats :: String -> Stats -> [String] -> [String] -> Stats
newStats w (Stats a b c d e) h t = case (Data.List.isInfixOf [w] h, Data.List.isInfixOf [w] t) of
	(True, True) -> Stats (a+1) b c d (e + wordocc (h ++ t) w)
	(True, False) -> Stats a (b+1) c d (e + wordocc (h ++ t) w)
	(False, True) -> Stats a b (c+1) d (e + wordocc (h ++ t) w)
	(False, False) -> Stats a b c (d+1) (e + wordocc (h ++ t) w)
	--last line doesn't get called because we only check words actually in the file. 
	--This can be gotten around by subtracting the first three fields from 
	--the total number of articles, and it will save time. 

main :: IO ()
main = do
	args <- getArgs
	let filelist = args !! 0 
		in do 
		    files <- readFile filelist
		    results <- helper (lines files) M.empty
		    print results

helper :: [String] -> WordMap -> IO WordMap
helper [] m = do return m
helper files m = do
		contents <- mapM S.readFile (take 100 files)
		helper (drop 100 files) (doAll contents m)
