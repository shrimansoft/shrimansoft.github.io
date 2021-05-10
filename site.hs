--------------------------------------------------------------------------------
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-deferred-type-errors #-}
import           Data.Monoid (mappend)
import           Hakyll
import           Hakyll.Core.Compiler (unsafeCompiler)
-- import           Hakyll.Web.Sass
import           KaTeX.KaTeXIPC      (kaTeXifyIO)
-- import           System.FilePath  (splitExtension)


--------------------------------------------------------------------------------
config :: Configuration
config = defaultConfiguration
  { destinationDirectory = "docs"
    -- , previewHost          = "10.0.2.30"
    , previewPort          = 8000
 }
--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
    match "assets/images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "assets/css/*.css" $ do
        route   idRoute
        compile compressCssCompiler
    
    -- scssDependency <- makePatternDependency "assets/css/**.scss"

    -- rulesExtraDependencies [scssDependency]
    --     $ match "assets/css/**.scss"
    --     $ do
    --         route $ setExtension "css"
    --         compile (fmap compressCss <$> sassCompiler)

    match "assets/javascript/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/post.html"    (postCtx "Posts")
            >>= loadAndApplyTemplate "templates/default.html" (postCtx "Posts")
            >>= relativizeUrls


    match "notes/*" $ do
        route $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/notes.html"   (postCtx "Notes")
            >>= loadAndApplyTemplate "templates/default.html" (postCtx "Notes")
            >>= relativizeUrls



    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" (postCtx "Poste-test") (return posts)  <>
                    constField "pageTitle" "Archives"         <>    
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["notes.html"] $ do
        route idRoute
        compile $ do
            notes <- recentFirst =<< loadAll "notes/*"
            let archiveCtx =
                    listField "notes" (postCtx "Notes-test") (return notes)  <>
                    constField "pageTitle" "Notes"         <>    
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/notes-page.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            notes <- recentFirst =<< loadAll "notes/*"

            let indexCtx =
                    listField "posts" (postCtx "Postes-test2") (return posts) <>
                    listField "notes" (postCtx "Postes-test2") (return notes) <>
                    constField "pageTitle" "Home"                <>
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: String -> Context String
postCtx pageTitle =
    dateField "date" "%B %e, %Y" <>
    constField "pageTitle" pageTitle   <>
    defaultContext


pandocMathCompiler :: Compiler (Item String)
pandocMathCompiler = do
  identifier <- getUnderlying
  s <- getMetadataField identifier "hls"
  case s of
    Just _ -> fail "this is the massage of error"
    --   pandocCompilerWithTransformM
    --      defaultHakyllReaderOptions defaultHakyllWriterOptions
    --      (unsafeCompiler . kaTeXifyIO)
    Nothing -> 
      pandocCompilerWithTransformM
         defaultHakyllReaderOptions defaultHakyllWriterOptions
         (unsafeCompiler . kaTeXifyIO)
        -- fail (("pandocCompiler is called, value of s is:  " ++ show s) ++ (" value of identifier is: " ++ show identifier))
        -- pandocCompiler