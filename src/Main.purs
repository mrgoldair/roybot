
-- data Heading = North | South | East | West
-- type Position = { x::Int, y::Int }
-- data Piece = Piece Heading Position

-- data Turn = CCW | CW
-- data Move = Forward | Backward
-- data Input = Move | Turn

-- turn :: Turn -> Piece -> Piece
-- turn CCW (Piece North position) = (Piece West position)
-- turn CCW (Piece South position) = (Piece East position)
-- turn CCW (Piece West position) = (Piece South position)
-- turn CCW (Piece East position) = (Piece North position)
-- turn CW (Piece North position) = (Piece East position)
-- turn CW (Piece South position) = (Piece West position)
-- turn CW (Piece East position) = (Piece South position)
-- turn CW (Piece West position) = (Piece North position)

-- move :: Move -> Piece -> Piece
-- move Forward (Piece North { x,y }) = Piece North { x:2, y:y + 1  }
-- move Forward (Piece South { x,y }) = Piece South { x:x, y:y - 1 }
-- move Forward (Piece East { x,y }) = (Piece East { x:x - 1, y:y })
-- move Forward (Piece West { x,y }) = (Piece West { x:x + 1, y })
-- move Backward (Piece North { x,y }) = (Piece North { x:x, y:y - 1 })
-- move Backward (Piece South { x,y }) = (Piece South { x:x, y:y + 1 })
-- move Backward (Piece East { x,y }) = (Piece East { x:x + 1, y:y })
-- move Backward (Piece West { x,y }) = (Piece West { x:x - 1, y:y })

-- moveGuard :: Move -> Piece -> Piece
-- moveGuard m p =
--   let
--     (Piece _ { x,y }) = move m p
--   in
--     if x > 5 || y < 0
--     then p
--     else move m 
module Main where

import Prelude

import Data.Array (range)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

type State = Int
data Action = Increment | Decrement

--
grid :: forall w i. HH.HTML w i
grid =
  HH.div_ (map (\_ -> HH.div_ [ HH.text "div" ]) (range 1 25))

-- grid :: Int -> Int -> Int -> Int -> (Tuple Int Int)
-- grid d s r s =
--   let
--     n = \ d s
--   in ( n * r, n * c )

component :: forall query i o m. H.Component HH.HTML query i o m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval { handleAction = handleAction }
    }
  where
  initialState :: forall input. input -> State
  initialState _ = 0

  render :: forall m. State -> H.ComponentHTML Action () m
  render state =
    HH.div_
      [ HH.button [ HE.onClick \_ -> Just Decrement ] [ HH.text "-" ]
      , HH.div_ [ HH.text $ show state ]
      , HH.button [ HE.onClick \_ -> Just Increment ] [ HH.text "+" ]
      , grid
      ]

  handleAction :: forall output m. Action -> H.HalogenM State Action () output m Unit
  handleAction = case _ of
    Increment ->
      H.modify_ \state -> state + 1
    Decrement ->
      H.modify_ \state -> state - 1