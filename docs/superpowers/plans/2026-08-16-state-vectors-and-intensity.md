# State Vectors, Stocks and Intensity Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reconciled, partition-indexed stock panels over kernel units, and an `intensity` operator producing `Density` cells (e.g. K/N as money per worker) — the raw material of the ψ distribution matrix.

**Architecture:** Per-stock group enums (regions included) index `StateVector g b`, whose only constructor reconciles components against an observed total (rule b). `Stock (r :: Role) g b` is a contiguous period-indexed family of state vectors, role-tagged so `intensity` can only take a `Base` in the denominator. Cells are kernel `Unit b`; densities are kernel `Per b c`. All partiality is `Maybe` at construction; all role/partition/dimension rules are compile errors.

**Tech Stack:** Haskell, Stack lts-23.28 (GHC 9.8.4), `base`, `containers`; tests with tasty + tasty-hunit + tasty-quickcheck (+ QuickCheck orphans already in `test/Kalecky/Types/NumericsSpec.hs`).

**Spec:** `docs/superpowers/specs/2026-08-16-state-vectors-and-intensity-design.md`

## Global Constraints

- Tree is design, one concept per file — exact paths below; never consolidate.
- **Module comments are ONLY math in `\[ … \]` notation** (TODO equations where they exist, derived equations otherwise). No prose Haddock, no `-- |` sentences in the new modules. Test modules may have a one-line header.
- Data constructors hidden unless the spec exports them (`Role`, group enums, `Density`'s ratio accessor is a function).
- Every task: **co-design gate** — show the test code to the user and get approval BEFORE implementing (Step 2 in each task). Commit pairs: `test(kalecky): … (RED)` then `feat(kalecky): … (GREEN)`.
- Verify with `stack test` and `scripts/check-compile-fail.sh` from the repo root; both must stay green after every GREEN commit.
- Cabal: add each new module to `exposed-modules` (library) / `other-modules` (test-suite) in `kalecky-semantics.cabal`; register each new test group in `test/Main.hs`. The library gains `containers` in `build-depends` (Task 4).
- Existing kernel API to consume (do not modify): `Kalecky.Types.Units.Unit` (`Unit`, `unit`, `qty`, `unitScale`, `value`, `align`, `add`, `scaleBy`, `HasScale(..)`), `Kalecky.Types.Numerics` (`Scale`, `scale`, `scaleFactor`), `Kalecky.Types.Units.TimeUnit` (`TimeBasis(..)`, `timeScale`), `Kalecky.Types.Units.MoneyUnit` (`Denomination(..)`, `MoneyBasis`, `moneyUnit`), `Kalecky.Types.Units.LaborUnit` (`WorkerBasis(..)`), `Kalecky.Types.Units.CompoundUnit` (`Per`, `per`, `numerator`, `denominator`), `Kalecky.Types.Currency` (`Currency(..)`).

---

## File Structure

| File | Responsibility |
|---|---|
| `src/Kalecky/Types/Units/IndexUnit.hs` | `IndexBasis = Index`, dimensionless basis (scale 1) for technology `A` |
| `src/Kalecky/Types/Groups/Population.hs` | `PopulationGroup` enum |
| `src/Kalecky/Types/Groups/Capital.hs` | `CapitalGroup` enum |
| `src/Kalecky/Types/Groups/Labor.hs` | `LaborGroup` enum |
| `src/Kalecky/Types/Groups/Education.hs` | `EducationGroup` enum |
| `src/Kalecky/Types/Groups/Region.hs` | `Region = Central \| Periphery` |
| `src/Kalecky/Types/Panel/Period.hs` | `Period` (granularity + ordinal), `next`, `compareP` |
| `src/Kalecky/Types/Panel/Panel.hs` | economics-free rectangular `Panel g t v`, `panel`, `window`, queries |
| `src/Kalecky/Types/Stocks/StateVector.hs` | reconciled `StateVector g b`, `component`, `total`, `share` |
| `src/Kalecky/Types/Stocks/Stock.hs` | `Role`, `Stock r g b`, `stock`, `point`, `at`, `series`, `totals`, `toPanel` |
| `src/Kalecky/Operators/Intensity.hs` | `Density b c`, `Intensity g h b c`, `intensity`, density queries |
| `test/Kalecky/Types/Units/IndexUnitSpec.hs` … one spec per module, mirroring the tree | tests |
| `test/should-fail/{BaseInNumerator,LevelAsBase,PartitionMix,GroupMix}.hs` | compile-fail boundaries |

---

### Task 1: IndexBasis

**Files:**
- Create: `src/Kalecky/Types/Units/IndexUnit.hs`
- Create: `test/Kalecky/Types/Units/IndexUnitSpec.hs`
- Modify: `kalecky-semantics.cabal` (exposed-modules, other-modules), `test/Main.hs`

**Interfaces:**
- Consumes: `HasScale(..)` from `Kalecky.Types.Units.Unit`; `scale` from `Kalecky.Types.Numerics`
- Produces: `data IndexBasis = Index` with `instance HasScale IndexBasis` (scale factor 1)

- [ ] **Step 1: Write the failing test**

```haskell
-- test/Kalecky/Types/Units/IndexUnitSpec.hs
module Kalecky.Types.Units.IndexUnitSpec (indexUnitTests) where

import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))
import Test.Tasty.QuickCheck (testProperty)

import Kalecky.Types.Numerics (scaleFactor)
import Kalecky.Types.NumericsSpec ()
import Kalecky.Types.Units.IndexUnit (IndexBasis (..))
import Kalecky.Types.Units.Unit (scaleOf, unit, value)

indexUnitTests :: TestTree
indexUnitTests =
  testGroup
    "IndexUnit"
    [ testGroup
        "laws"
        [ testProperty "dimensionless: value (unit Index k) == k" $
            \k -> value (unit Index k) == k
        ]
    , testGroup
        "examples"
        [ testCase "scale of Index is exactly 1" $
            scaleFactor (scaleOf Index) @?= 1
        ]
    ]
```

- [ ] **Step 2: Co-design gate** — show the test to the user; proceed only on approval.

- [ ] **Step 3: Write the RED skeleton and wire it**

```haskell
-- src/Kalecky/Types/Units/IndexUnit.hs
-- \[ s(1,1) = 1^{1} = 1 \]
-- \[ u_{1}(k) = k \]
module Kalecky.Types.Units.IndexUnit
  ( IndexBasis (..)
  ) where

import Kalecky.Types.Numerics (scale)
import Kalecky.Types.Units.Unit (HasScale (..))

data IndexBasis = Index
  deriving (Eq, Ord, Show, Enum, Bounded)

instance HasScale IndexBasis where
  scaleOf Index = undefined
```

In `kalecky-semantics.cabal` add `Kalecky.Types.Units.IndexUnit` under the library's `exposed-modules` and `Kalecky.Types.Units.IndexUnitSpec` under the test-suite's `other-modules`. In `test/Main.hs` add `import Kalecky.Types.Units.IndexUnitSpec (indexUnitTests)` and `, indexUnitTests` to the `tests` list.

- [ ] **Step 4: Run to verify RED**

Run: `stack test 2>&1 | grep -E "tests (passed|failed)"`
Expected: `2 out of 109 tests failed` (the two new tests fail on `undefined`).

- [ ] **Step 5: Commit RED**

```bash
git add src/Kalecky/Types/Units/IndexUnit.hs test/Kalecky/Types/Units/IndexUnitSpec.hs kalecky-semantics.cabal test/Main.hs
git commit -m "test(kalecky): add approved IndexBasis laws (RED)"
```

- [ ] **Step 6: Implement**

Replace the instance body:

```haskell
instance HasScale IndexBasis where
  scaleOf Index = case scale 1 1 of
    Just s -> s
    Nothing -> error "unreachable: base 1 >= 1"
```

- [ ] **Step 7: Run to verify GREEN**

Run: `stack test 2>&1 | grep -E "tests passed"`
Expected: `All 109 tests passed`

- [ ] **Step 8: Commit GREEN**

```bash
git add src/Kalecky/Types/Units/IndexUnit.hs
git commit -m "feat(kalecky): add dimensionless IndexBasis (GREEN)"
```

---

### Task 2: Group enums (five modules)

**Files:**
- Create: `src/Kalecky/Types/Groups/Population.hs`, `Capital.hs`, `Labor.hs`, `Education.hs`, `Region.hs`
- Create: `test/Kalecky/Types/Groups/GroupsSpec.hs`
- Modify: `kalecky-semantics.cabal`, `test/Main.hs`

**Interfaces:**
- Produces: `PopulationGroup = NK | NF | NLI | NL | NML`, `CapitalGroup = KF | KK | KMC`, `LaborGroup = LI | LF | LML`, `EducationGroup = EPublic | EPrivate`, `Region = Central | Periphery` — all deriving `Eq, Ord, Show, Enum, Bounded`.

- [ ] **Step 1: Write the failing test**

```haskell
-- test/Kalecky/Types/Groups/GroupsSpec.hs
module Kalecky.Types.Groups.GroupsSpec (groupsTests) where

import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))

import Kalecky.Types.Groups.Capital (CapitalGroup (..))
import Kalecky.Types.Groups.Education (EducationGroup (..))
import Kalecky.Types.Groups.Labor (LaborGroup (..))
import Kalecky.Types.Groups.Population (PopulationGroup (..))
import Kalecky.Types.Groups.Region (Region (..))

groupsTests :: TestTree
groupsTests =
  testGroup
    "Groups"
    [ testCase "population partition is exactly {NK, NF, NLI, NL, NML}" $
        [minBound .. maxBound] @?= [NK, NF, NLI, NL, NML]
    , testCase "capital partition is exactly {KF, KK, KMC}" $
        [minBound .. maxBound] @?= [KF, KK, KMC]
    , testCase "labor partition is exactly {LI, LF, LML}" $
        [minBound .. maxBound] @?= [LI, LF, LML]
    , testCase "education partition is exactly {EPublic, EPrivate}" $
        [minBound .. maxBound] @?= [EPublic, EPrivate]
    , testCase "regions are exactly {Central, Periphery}" $
        [minBound .. maxBound] @?= [Central, Periphery]
    ]
```

- [ ] **Step 2: Co-design gate** — show the test and the five enums to the user; proceed only on approval.

- [ ] **Step 3: Create the five modules** (enums have no bodies to stub; RED here is "does not compile until the modules exist" — so create the test + cabal wiring first, run `stack test` to observe the module-not-found failure, then add the modules)

```haskell
-- src/Kalecky/Types/Groups/Population.hs
-- \[
--   N =
--   \begin{bmatrix}
--     N_K \\ N_F \\ N_{LI} \\ N_{L} \\ N_{ML} \\ \sum N_i
--   \end{bmatrix}
-- \]
module Kalecky.Types.Groups.Population (PopulationGroup (..)) where

data PopulationGroup = NK | NF | NLI | NL | NML
  deriving (Eq, Ord, Show, Enum, Bounded)
```

```haskell
-- src/Kalecky/Types/Groups/Capital.hs
-- \[ K = K_F \oplus K_K \oplus K_{MC} \]
module Kalecky.Types.Groups.Capital (CapitalGroup (..)) where

data CapitalGroup = KF | KK | KMC
  deriving (Eq, Ord, Show, Enum, Bounded)
```

```haskell
-- src/Kalecky/Types/Groups/Labor.hs
-- \[ L = L_I \oplus L_F \oplus L_{ML} \]
module Kalecky.Types.Groups.Labor (LaborGroup (..)) where

data LaborGroup = LI | LF | LML
  deriving (Eq, Ord, Show, Enum, Bounded)
```

```haskell
-- src/Kalecky/Types/Groups/Education.hs
-- \[ E = E_G \oplus E_{pr} \]
module Kalecky.Types.Groups.Education (EducationGroup (..)) where

data EducationGroup = EPublic | EPrivate
  deriving (Eq, Ord, Show, Enum, Bounded)
```

```haskell
-- src/Kalecky/Types/Groups/Region.hs
-- \[ X = X_{C} \oplus X_{P} \]
module Kalecky.Types.Groups.Region (Region (..)) where

data Region = Central | Periphery
  deriving (Eq, Ord, Show, Enum, Bounded)
```

Wire all five into `exposed-modules`, `Kalecky.Types.Groups.GroupsSpec` into `other-modules`, and `groupsTests` into `test/Main.hs`.

- [ ] **Step 4: Run to verify GREEN**

Run: `stack test 2>&1 | grep -E "tests passed"`
Expected: `All 114 tests passed`

- [ ] **Step 5: Commit** (single commit — enums carry no logic to RED)

```bash
git add src/Kalecky/Types/Groups test/Kalecky/Types/Groups kalecky-semantics.cabal test/Main.hs
git commit -m "feat(kalecky): add partition group enums (population, capital, labor, education, region)"
```

---

### Task 3: Period

**Files:**
- Create: `src/Kalecky/Types/Panel/Period.hs`, `test/Kalecky/Types/Panel/PeriodSpec.hs`
- Modify: `kalecky-semantics.cabal`, `test/Main.hs`

**Interfaces:**
- Consumes: `TimeBasis(..)` from `Kalecky.Types.Units.TimeUnit`
- Produces: `Period` (ctor hidden; derives `Eq, Ord, Show` — the derived `Ord` exists only so `Period` can key a `Map`; economic ordering is `compareP`), `period :: TimeBasis -> Natural -> Period`, `granularity :: Period -> TimeBasis`, `ordinal :: Period -> Natural`, `next :: Period -> Period`, `compareP :: Period -> Period -> Maybe Ordering`

- [ ] **Step 1: Write the failing test**

```haskell
-- test/Kalecky/Types/Panel/PeriodSpec.hs
module Kalecky.Types.Panel.PeriodSpec (periodTests) where

import Numeric.Natural (Natural)
import Test.QuickCheck (Arbitrary (..))
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (testCase, (@?=))
import Test.Tasty.QuickCheck (testProperty)

import Kalecky.Types.NumericsSpec ()
import Kalecky.Types.Panel.Period (Period, compareP, granularity, next, ordinal, period)
import Kalecky.Types.Units.TimeUnit (TimeBasis (..))

instance Arbitrary Period where
  arbitrary = period <$> arbitrary <*> arbitrary

periodTests :: TestTree
periodTests =
  testGroup
    "Period"
    [ testGroup
        "laws"
        [ testProperty "next keeps granularity and increments the ordinal" $
            \(p :: Period) ->
              granularity (next p) == granularity p && ordinal (next p) == ordinal p + 1
        , testProperty "next is strictly later within a granularity" $
            \(p :: Period) -> compareP p (next p) == Just LT
        , testProperty "within a granularity, compareP agrees with ordinal order" $
            \(g :: TimeBasis) (a :: Natural) (b :: Natural) ->
              compareP (period g a) (period g b) == Just (compare a b)
        , testProperty "across granularities, compareP is Nothing" $
            \(a :: Natural) (b :: Natural) ->
              compareP (period Month a) (period Hour b) == Nothing
        ]
    , testGroup
        "examples"
        [ testCase "the 3rd month is Period Month 3" $ do
            granularity (period Month 3) @?= Month
            ordinal (period Month 3) @?= 3
        ]
    ]
```

- [ ] **Step 2: Co-design gate** — approval before implementing.

- [ ] **Step 3: RED skeleton + wiring**

```haskell
-- src/Kalecky/Types/Panel/Period.hs
-- \[ t = (g, n), \qquad g \in \{\text{Hour}, \text{Month}\}, \; n \in \mathbb{N} \]
-- \[ \operatorname{next}(g, n) = (g, n + 1) \]
-- \[ (g, n) \prec (g, m) \iff n < m ; \qquad (g, n) \not\sim (g', m) \text{ for } g \neq g' \]
module Kalecky.Types.Panel.Period
  ( Period
  , period
  , granularity
  , ordinal
  , next
  , compareP
  ) where

import Numeric.Natural (Natural)

import Kalecky.Types.Units.TimeUnit (TimeBasis)

data Period = Period TimeBasis Natural
  deriving (Eq, Ord, Show)

period :: TimeBasis -> Natural -> Period
period = undefined

granularity :: Period -> TimeBasis
granularity = undefined

ordinal :: Period -> Natural
ordinal = undefined

next :: Period -> Period
next = undefined

compareP :: Period -> Period -> Maybe Ordering
compareP = undefined
```

Wire `Kalecky.Types.Panel.Period` / `Kalecky.Types.Panel.PeriodSpec` / `periodTests`.

- [ ] **Step 4: Verify RED** — `stack test` → `5 out of 119 tests failed`.

- [ ] **Step 5: Commit RED** — `git commit -m "test(kalecky): add approved Period laws (RED)"` (add the two files + cabal + Main).

- [ ] **Step 6: Implement**

```haskell
period :: TimeBasis -> Natural -> Period
period = Period

granularity :: Period -> TimeBasis
granularity (Period g _) = g

ordinal :: Period -> Natural
ordinal (Period _ n) = n

next :: Period -> Period
next (Period g n) = Period g (n + 1)

compareP :: Period -> Period -> Maybe Ordering
compareP (Period g n) (Period h m)
  | g == h = Just (compare n m)
  | otherwise = Nothing
```

- [ ] **Step 7: Verify GREEN** — `stack test` → `All 119 tests passed`.

- [ ] **Step 8: Commit GREEN** — `git commit -m "feat(kalecky): implement Period (GREEN)"`.

---

### Task 4: Panel

**Files:**
- Create: `src/Kalecky/Types/Panel/Panel.hs`, `test/Kalecky/Types/Panel/PanelSpec.hs`
- Modify: `kalecky-semantics.cabal` (add `containers` to library `build-depends`), `test/Main.hs`

**Interfaces:**
- Consumes: `Data.Map.Strict`
- Produces:
  ```haskell
  data Panel g t v                                   -- ctor hidden; Eq, Show
  panel   :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> (g -> t -> v) -> Panel g t v
  window  :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> [(g, t, v)] -> Maybe (Panel g t v)
  cell    :: (Ord g, Ord t) => g -> t -> Panel g t v -> Maybe v
  row     :: (Ord g, Ord t) => g -> Panel g t v -> [(t, v)]
  column  :: (Bounded g, Enum g, Ord g, Ord t) => t -> Panel g t v -> Maybe (g -> v)
  groups  :: (Bounded g, Enum g) => Panel g t v -> [g]
  periods :: Panel g t v -> [t]
  ```
  `panel` de-duplicates its period list preserving first occurrence; `window` is `Just` iff every (group, period) of the requested period list appears exactly once in the observations (extra observations for other periods are ignored).

- [ ] **Step 1: Write the failing test**

```haskell
-- test/Kalecky/Types/Panel/PanelSpec.hs
module Kalecky.Types.Panel.PanelSpec (panelTests) where

import Data.List (nub, sort)
import Data.Maybe (isJust, isNothing)
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (assertBool, testCase, (@?=))
import Test.Tasty.QuickCheck (testProperty)

import Kalecky.Types.Groups.Region (Region (..))
import Kalecky.Types.Panel.Panel (cell, column, groups, panel, periods, row, window)

type P = Int  -- a stand-in period index; Panel is economics-free

panelTests :: TestTree
panelTests =
  testGroup
    "Panel"
    [ testGroup
        "laws"
        [ testProperty "rectangular: every (group, period) cell of a built panel is Just" $
            \(ts :: [P]) ->
              let p = panel ts (\g t -> (fromEnum (g :: Region), t))
               in and [isJust (cell g t p) | g <- groups p, t <- periods p]
        , testProperty "periods are the de-duplicated input, in order" $
            \(ts :: [P]) -> periods (panel ts (\(_ :: Region) t -> t)) == nub ts
        , testProperty "row and cell agree" $
            \(ts :: [P]) ->
              let p = panel ts (\(g :: Region) t -> (g, t))
               in and [row g p == [(t, (g, t)) | t <- periods p] | g <- groups p]
        , testProperty "column reproduces the generating function" $
            \(ts :: [P]) (t :: P) ->
              let p = panel ts (\(g :: Region) t' -> (g, t'))
               in case column t p of
                    Nothing -> t `notElem` ts
                    Just f -> and [f g == (g, t) | g <- [minBound .. maxBound]]
        , testProperty "window succeeds iff the requested block is fully covered exactly once" $
            \(ts :: [P]) ->
              let complete = [(g, t, ()) | g <- [minBound .. maxBound :: Region], t <- nub ts]
               in isJust (window (nub ts) complete)
                    && (null ts || isNothing (window (nub ts) (drop 1 complete)))
        ]
    , testGroup
        "examples"
        [ testCase "a single data point is a one-cell panel" $ do
            let p = panel [7 :: P] (\(_ :: Region) _ -> "x")
            length [() | g <- groups p, t <- periods p, isJust (cell g t p)] @?= 2
            periods p @?= [7]
        , testCase "window ignores observations outside the requested periods" $ do
            let obs = [(Central, 1 :: P, 'a'), (Periphery, 1, 'b'), (Central, 9, 'z')]
            assertBool "block [1] covered" (isJust (window [1] obs))
            fmap (\p -> sort (periods p)) (window [1] obs) @?= Just [1]
        ]
    ]
```

- [ ] **Step 2: Co-design gate.**

- [ ] **Step 3: RED skeleton + wiring** (add `containers` to the library `build-depends`)

```haskell
-- src/Kalecky/Types/Panel/Panel.hs
-- \[ P : G \times T \to V \]
-- \[ \operatorname{dom}(P) = G \times T \]
module Kalecky.Types.Panel.Panel
  ( Panel
  , panel
  , window
  , cell
  , row
  , column
  , groups
  , periods
  ) where

import Data.List (nub)
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

data Panel g t v = Panel [t] (Map (g, t) v)
  deriving (Eq, Show)

panel :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> (g -> t -> v) -> Panel g t v
panel = undefined

window :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> [(g, t, v)] -> Maybe (Panel g t v)
window = undefined

cell :: (Ord g, Ord t) => g -> t -> Panel g t v -> Maybe v
cell = undefined

row :: (Ord g, Ord t) => g -> Panel g t v -> [(t, v)]
row = undefined

column :: (Bounded g, Enum g, Ord g, Ord t) => t -> Panel g t v -> Maybe (g -> v)
column = undefined

groups :: (Bounded g, Enum g) => Panel g t v -> [g]
groups = undefined

periods :: Panel g t v -> [t]
periods = undefined
```

- [ ] **Step 4: Verify RED** — `stack test` → `7 out of 126 tests failed`.

- [ ] **Step 5: Commit RED** — `git commit -m "test(kalecky): add approved Panel laws (RED)"`.

- [ ] **Step 6: Implement**

```haskell
panel :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> (g -> t -> v) -> Panel g t v
panel ts f =
  let ts' = nub ts
   in Panel ts' (Map.fromList [((g, t), f g t) | g <- [minBound .. maxBound], t <- ts'])

window :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> [(g, t, v)] -> Maybe (Panel g t v)
window ts obs =
  let ts' = nub ts
      wanted = [(g, t) | g <- [minBound .. maxBound], t <- ts']
      inBlock = [((g, t), v) | (g, t, v) <- obs, t `elem` ts']
      keys = map fst inBlock
   in if length inBlock == length wanted
        && all (`elem` keys) wanted
        && length (nub keys) == length inBlock
        then Just (Panel ts' (Map.fromList inBlock))
        else Nothing
```

Then:

```haskell
cell :: (Ord g, Ord t) => g -> t -> Panel g t v -> Maybe v
cell g t (Panel _ m) = Map.lookup (g, t) m

row :: (Ord g, Ord t) => g -> Panel g t v -> [(t, v)]
row g (Panel ts m) = [(t, v) | t <- ts, Just v <- [Map.lookup (g, t) m]]

column :: (Bounded g, Enum g, Ord g, Ord t) => t -> Panel g t v -> Maybe (g -> v)
column t (Panel ts m)
  | t `elem` ts = Just (\g -> m Map.! (g, t))
  | otherwise = Nothing

groups :: (Bounded g, Enum g) => Panel g t v -> [g]
groups _ = [minBound .. maxBound]

periods :: Panel g t v -> [t]
periods (Panel ts _) = ts
```

- [ ] **Step 7: Verify GREEN** — `stack test` → `All 126 tests passed`.

- [ ] **Step 8: Commit GREEN** — `git commit -m "feat(kalecky): implement rectangular Panel with window loader (GREEN)"`.

---

### Task 5: StateVector

**Files:**
- Create: `src/Kalecky/Types/Stocks/StateVector.hs`, `test/Kalecky/Types/Stocks/StateVectorSpec.hs`
- Modify: `kalecky-semantics.cabal`, `test/Main.hs`

**Interfaces:**
- Consumes: `Unit`, `value` from `Kalecky.Types.Units.Unit`; `Data.Map.Strict`
- Produces:
  ```haskell
  data StateVector g b                                -- ctor hidden; Eq, Show
  stateVector :: (Bounded g, Enum g, Ord g) => (g -> Unit b) -> Unit b -> Maybe (StateVector g b)
    -- Just iff Σ value(f g) == value total AND value total > 0
  component   :: Ord g => g -> StateVector g b -> Unit b
  total       :: StateVector g b -> Unit b
  share       :: Ord g => g -> StateVector g b -> Rational   -- value(component) / value(total)
  ```

- [ ] **Step 1: Write the failing test**

```haskell
-- test/Kalecky/Types/Stocks/StateVectorSpec.hs
module Kalecky.Types.Stocks.StateVectorSpec (stateVectorTests) where

import Data.Maybe (fromJust, isJust, isNothing)
import Numeric.Natural (Natural)
import Test.QuickCheck ((==>))
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (assertBool, testCase, (@?=))
import Test.Tasty.QuickCheck (testProperty)

import Kalecky.Types.Currency (Currency (..))
import Kalecky.Types.Groups.Capital (CapitalGroup (..))
import Kalecky.Types.Groups.Population (PopulationGroup (..))
import Kalecky.Types.NumericsSpec ()
import Kalecky.Types.Stocks.StateVector (StateVector, component, share, stateVector, total)
import Kalecky.Types.Units.LaborUnit (WorkerBasis (..))
import Kalecky.Types.Units.MoneyUnit (Denomination (..), MoneyBasis, moneyUnit)
import Kalecky.Types.Units.Unit (Unit, unit, value)

-- five population components, then the total is their sum
pop :: [Natural] -> (PopulationGroup -> Unit WorkerBasis)
pop ks g = unit Worker (ks !! fromEnum g)

stateVectorTests :: TestTree
stateVectorTests =
  testGroup
    "StateVector"
    [ testGroup
        "laws"
        [ testProperty "Just iff the components sum exactly to the total (and total > 0)" $
            \(a :: Natural) (b :: Natural) (c :: Natural) (d :: Natural) (e :: Natural) (t :: Natural) ->
              let ks = [a, b, c, d, e]
               in isJust (stateVector (pop ks) (unit Worker t))
                    == (sum ks == t && t > 0)
        , testProperty "shares sum to exactly 1" $
            \(a :: Natural) (b :: Natural) (c :: Natural) (d :: Natural) (e :: Natural) ->
              let ks = [a, b, c, d, e]; t = sum ks
               in t > 0 ==>
                    let v = fromJust (stateVector (pop ks) (unit Worker t))
                     in sum [share g v | g <- [minBound .. maxBound]] == 1
        , testProperty "components and total round-trip" $
            \(a :: Natural) (b :: Natural) (c :: Natural) (d :: Natural) (e :: Natural) ->
              let ks = [a, b, c, d, e]; t = sum ks
               in t > 0 ==>
                    let v = fromJust (stateVector (pop ks) (unit Worker t))
                     in value (total v) == t && [value (component g v) | g <- [minBound .. maxBound]] == ks
        ]
    , testGroup
        "examples"
        [ testCase "N reconciles: 5 groups summing to the observed total" $
            assertBool "expected Just" (isJust (stateVector (pop [10, 20, 30, 40, 50]) (unit Worker 150)))
        , testCase "N off by one worker does not reconcile" $
            assertBool "expected Nothing" (isNothing (stateVector (pop [10, 20, 30, 40, 50]) (unit Worker 151)))
        , testCase "K = K_F + K_K + K_MC in Thousand COP reconciles against a Raw-COP total" $ do
            let k g = fromJust (moneyUnit @COP Thousand ([100, 250, 50] !! fromEnum (g :: CapitalGroup)))
                tot = fromJust (moneyUnit @COP Raw 400000)
                v = fromJust (stateVector k tot) :: StateVector CapitalGroup (MoneyBasis COP)
            share KK v @?= 250 / 400
        ]
    ]
```

- [ ] **Step 2: Co-design gate.**

- [ ] **Step 3: RED skeleton + wiring**

```haskell
-- src/Kalecky/Types/Stocks/StateVector.hs
-- \[
--   N =
--   \begin{bmatrix}
--     N_K \\ N_F \\ N_{LI} \\ N_{L} \\ N_{ML} \\ \sum N_i
--   \end{bmatrix}
-- \]
-- \[ \sum_{i \in G} N_i = N, \qquad N > 0 \]
-- \[ \sigma_i = \frac{N_i}{N}, \qquad \sum_{i \in G} \sigma_i = 1 \]
module Kalecky.Types.Stocks.StateVector
  ( StateVector
  , stateVector
  , component
  , total
  , share
  ) where

import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import Data.Ratio ((%))

import Kalecky.Types.Units.Unit (Unit, value)

data StateVector g b = StateVector (Map g (Unit b)) (Unit b)
  deriving (Eq, Show)

stateVector :: (Bounded g, Enum g, Ord g) => (g -> Unit b) -> Unit b -> Maybe (StateVector g b)
stateVector = undefined

component :: Ord g => g -> StateVector g b -> Unit b
component = undefined

total :: StateVector g b -> Unit b
total = undefined

share :: Ord g => g -> StateVector g b -> Rational
share = undefined
```

- [ ] **Step 4: Verify RED** — `stack test` → `6 out of 132 tests failed`.

- [ ] **Step 5: Commit RED** — `git commit -m "test(kalecky): add approved StateVector reconciliation laws (RED)"`.

- [ ] **Step 6: Implement**

```haskell
stateVector :: (Bounded g, Enum g, Ord g) => (g -> Unit b) -> Unit b -> Maybe (StateVector g b)
stateVector f tot
  | value tot > 0 && sum (map (value . f) gs) == value tot =
      Just (StateVector (Map.fromList [(g, f g) | g <- gs]) tot)
  | otherwise = Nothing
  where
    gs = [minBound .. maxBound]

component :: Ord g => g -> StateVector g b -> Unit b
component g (StateVector m _) = m Map.! g

total :: StateVector g b -> Unit b
total (StateVector _ t) = t

share :: Ord g => g -> StateVector g b -> Rational
share g v = toInteger (value (component g v)) % toInteger (value (total v))
```

- [ ] **Step 7: Verify GREEN** — `stack test` → `All 132 tests passed`.

- [ ] **Step 8: Commit GREEN** — `git commit -m "feat(kalecky): implement reconciled StateVector (GREEN)"`.

---

### Task 6: Stock

**Files:**
- Create: `src/Kalecky/Types/Stocks/Stock.hs`, `test/Kalecky/Types/Stocks/StockSpec.hs`
- Modify: `kalecky-semantics.cabal`, `test/Main.hs`

**Interfaces:**
- Consumes: `StateVector`, `component`, `total` (Task 5); `Period`, `granularity`, `ordinal` (Task 3); `Panel`, `panel` (Task 4); `Data.Map.Strict`
- Produces:
  ```haskell
  data Role = Base | Level                              -- promoted via DataKinds
  data Stock (r :: Role) g b                            -- ctor hidden; Eq, Show
  stock   :: [(Period, StateVector g b)] -> Maybe (Stock r g b)
    -- Just iff non-empty, no repeated periods, one granularity, ordinals contiguous (in any input order)
  point   :: Period -> StateVector g b -> Stock r g b
  at      :: Period -> Stock r g b -> Maybe (StateVector g b)
  series  :: Ord g => g -> Stock r g b -> [(Period, Unit b)]
  totals  :: Stock r g b -> [(Period, Unit b)]
  toPanel :: (Bounded g, Enum g, Ord g) => Stock r g b -> Panel g Period (Unit b)
  ```
  Note: the spec's `point :: StateVector g b -> Stock r g b` needs a period to be a one-column panel; the plan gives `point` an explicit `Period` argument.

- [ ] **Step 1: Write the failing test**

```haskell
-- test/Kalecky/Types/Stocks/StockSpec.hs
module Kalecky.Types.Stocks.StockSpec (stockTests) where

import Data.Maybe (fromJust, isJust, isNothing)
import Numeric.Natural (Natural)
import Test.QuickCheck (Arbitrary (..), (==>))
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (assertBool, testCase, (@?=))
import Test.Tasty.QuickCheck (testProperty)

import Kalecky.Types.Groups.Region (Region (..))
import Kalecky.Types.NumericsSpec ()
import Kalecky.Types.Panel.Panel (cell)
import Kalecky.Types.Panel.Period (Period, next, period)
import Kalecky.Types.Stocks.StateVector (StateVector, component, stateVector, total)
import Kalecky.Types.Stocks.Stock (Role (..), Stock, at, point, series, stock, toPanel, totals)
import Kalecky.Types.Units.LaborUnit (WorkerBasis (..))
import Kalecky.Types.Units.TimeUnit (TimeBasis (..))
import Kalecky.Types.Units.Unit (unit, value)

-- a reconciled regional population vector with c central, p peripheral (both >= 1)
regional :: Natural -> Natural -> StateVector Region WorkerBasis
regional c p =
  fromJust (stateVector (\r -> unit Worker (if r == Central then c else p)) (unit Worker (c + p)))

instance Arbitrary (StateVector Region WorkerBasis) where
  arbitrary = regional <$> ((+ 1) <$> arbitrary) <*> ((+ 1) <$> arbitrary)

contiguous :: TimeBasis -> Natural -> [StateVector Region WorkerBasis] -> [(Period, StateVector Region WorkerBasis)]
contiguous g start vs = zip (iterate next (period g start)) vs

stockTests :: TestTree
stockTests =
  testGroup
    "Stock"
    [ testGroup
        "laws"
        [ testProperty "contiguous same-granularity periods build, in any order" $
            \(g :: TimeBasis) (start :: Natural) (vs :: [StateVector Region WorkerBasis]) ->
              not (null vs) ==>
                isJust (stock (reverse (contiguous g start vs)) :: Maybe (Stock Base Region WorkerBasis))
        , testProperty "a gap in the periods is rejected" $
            \(g :: TimeBasis) (start :: Natural) (v :: StateVector Region WorkerBasis) ->
              isNothing (stock [(period g start, v), (period g (start + 2), v)] :: Maybe (Stock Base Region WorkerBasis))
        , testProperty "a repeated period is rejected" $
            \(g :: TimeBasis) (start :: Natural) (v :: StateVector Region WorkerBasis) ->
              isNothing (stock [(period g start, v), (period g start, v)] :: Maybe (Stock Base Region WorkerBasis))
        , testProperty "mixed granularities are rejected" $
            \(v :: StateVector Region WorkerBasis) ->
              isNothing (stock [(period Month 1, v), (period Hour 2, v)] :: Maybe (Stock Base Region WorkerBasis))
        , testProperty "every at-column is the state vector that was put in" $
            \(g :: TimeBasis) (start :: Natural) (vs :: [StateVector Region WorkerBasis]) ->
              not (null vs) ==>
                let ps = contiguous g start vs
                    s = fromJust (stock ps) :: Stock Level Region WorkerBasis
                 in and [at p s == Just v | (p, v) <- ps]
        , testProperty "totals and series are consistent with the state vectors" $
            \(g :: TimeBasis) (start :: Natural) (vs :: [StateVector Region WorkerBasis]) ->
              not (null vs) ==>
                let ps = contiguous g start vs
                    s = fromJust (stock ps) :: Stock Level Region WorkerBasis
                 in map (fmap value) (totals s) == [(p, value (total v)) | (p, v) <- ps]
                      && map (fmap value) (series Central s)
                        == [(p, value (component Central v)) | (p, v) <- ps]
        ]
    , testGroup
        "examples"
        [ testCase "point is a one-period stock" $ do
            let s = point (period Month 5) (regional 3 4) :: Stock Base Region WorkerBasis
            map fst (totals s) @?= [period Month 5]
        , testCase "toPanel exposes the component cells" $ do
            let s = fromJust (stock (contiguous Month 1 [regional 3 4, regional 5 6])) :: Stock Base Region WorkerBasis
            fmap value (cell Periphery (period Month 2) (toPanel s)) @?= Just 6
        ]
    ]
```

- [ ] **Step 2: Co-design gate.**

- [ ] **Step 3: RED skeleton + wiring**

```haskell
-- src/Kalecky/Types/Stocks/Stock.hs
-- \[
--   FK =
--   \begin{bmatrix} K \\ L \\ E \\ A \end{bmatrix} =
--   \begin{bmatrix}
--     K_F \oplus K_K \oplus K_{MC} \\
--     L_I \oplus L_F \oplus L_{ML} \\
--     E_G \oplus E_{pr} \\
--     A
--   \end{bmatrix}
-- \]
-- \[ S : T \to \text{StateVector}, \qquad T = \{ (g, n), (g, n+1), \dots, (g, n+k) \} \]
module Kalecky.Types.Stocks.Stock
  ( Role (..)
  , Stock
  , stock
  , point
  , at
  , series
  , totals
  , toPanel
  ) where

import Data.List (sortOn)
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map

import Kalecky.Types.Panel.Panel (Panel, panel)
import Kalecky.Types.Panel.Period (Period, granularity, ordinal)
import Kalecky.Types.Stocks.StateVector (StateVector, component, total)
import Kalecky.Types.Units.Unit (Unit)

data Role = Base | Level
  deriving (Eq, Show)

data Stock (r :: Role) g b = Stock [Period] (Map Period (StateVector g b))
  deriving (Eq, Show)

stock :: [(Period, StateVector g b)] -> Maybe (Stock r g b)
stock = undefined

point :: Period -> StateVector g b -> Stock r g b
point = undefined

at :: Period -> Stock r g b -> Maybe (StateVector g b)
at = undefined

series :: Ord g => g -> Stock r g b -> [(Period, Unit b)]
series = undefined

totals :: Stock r g b -> [(Period, Unit b)]
totals = undefined

toPanel :: (Bounded g, Enum g, Ord g) => Stock r g b -> Panel g Period (Unit b)
toPanel = undefined
```

- [ ] **Step 4: Verify RED** — `stack test` → `8 out of 140 tests failed`.

- [ ] **Step 5: Commit RED** — `git commit -m "test(kalecky): add approved Stock sequence laws (RED)"`.

- [ ] **Step 6: Implement**

```haskell
stock :: [(Period, StateVector g b)] -> Maybe (Stock r g b)
stock [] = Nothing
stock ps
  | length (Map.keys m) /= length ps = Nothing                 -- repeated period
  | any ((/= g0) . granularity) periods' = Nothing             -- mixed granularity
  | map ordinal periods' /= take (length periods') [ordinal (head periods') ..] = Nothing  -- gap
  | otherwise = Just (Stock periods' m)
  where
    m = Map.fromList ps
    periods' = sortOn ordinal (Map.keys m)
    g0 = granularity (head periods')

point :: Period -> StateVector g b -> Stock r g b
point p v = Stock [p] (Map.singleton p v)

at :: Period -> Stock r g b -> Maybe (StateVector g b)
at p (Stock _ m) = Map.lookup p m

series :: Ord g => g -> Stock r g b -> [(Period, Unit b)]
series g (Stock ps m) = [(p, component g (m Map.! p)) | p <- ps]

totals :: Stock r g b -> [(Period, Unit b)]
totals (Stock ps m) = [(p, total (m Map.! p)) | p <- ps]

toPanel :: (Bounded g, Enum g, Ord g) => Stock r g b -> Panel g Period (Unit b)
toPanel (Stock ps m) = panel ps (\g p -> component g (m Map.! p))
```

- [ ] **Step 7: Verify GREEN** — `stack test` → `All 140 tests passed`.

- [ ] **Step 8: Commit GREEN** — `git commit -m "feat(kalecky): implement role-tagged Stock (GREEN)"`.

---

### Task 7: Intensity and Density

**Files:**
- Create: `src/Kalecky/Operators/Intensity.hs`, `test/Kalecky/Operators/IntensitySpec.hs`
- Modify: `kalecky-semantics.cabal`, `test/Main.hs`

**Interfaces:**
- Consumes: `Stock`, `Role(..)`, `at`, `totals` (Task 6); `StateVector`, `component`, `total` (Task 5); `Per`, `per`, `numerator`, `denominator` (kernel); `value` (kernel)
- Produces:
  ```haskell
  newtype Density b c = Density (Per b c)     -- ctor hidden; Eq, Show
  densityRatio  :: Density b c -> Per b c
  densityValue  :: Density b c -> Rational    -- value(numerator) / value(denominator)
  data Intensity g h b c                       -- ctor hidden
  intensity      :: Stock Level g b -> Stock Base h c -> Maybe (Intensity g h b c)   -- Just iff same period list
  totalDensity   :: Period -> Intensity g h b c -> Maybe (Density b c)
  groupDensity   :: Ord g => g -> Period -> Intensity g h b c -> Maybe (Density b c)
  matchedDensity :: Ord g => g -> Period -> Intensity g g b c -> Maybe (Density b c)
  ```

- [ ] **Step 1: Write the failing test**

```haskell
-- test/Kalecky/Operators/IntensitySpec.hs
module Kalecky.Operators.IntensitySpec (intensityTests) where

import Data.Maybe (fromJust, isJust, isNothing)
import Data.Ratio ((%))
import Numeric.Natural (Natural)
import Test.QuickCheck ((==>))
import Test.Tasty (TestTree, testGroup)
import Test.Tasty.HUnit (assertBool, testCase, (@?=))
import Test.Tasty.QuickCheck (testProperty)

import Kalecky.Operators.Intensity (densityValue, groupDensity, intensity, matchedDensity, totalDensity)
import Kalecky.Types.Currency (Currency (..))
import Kalecky.Types.Groups.Capital (CapitalGroup (..))
import Kalecky.Types.Groups.Region (Region (..))
import Kalecky.Types.NumericsSpec ()
import Kalecky.Types.Panel.Period (period)
import Kalecky.Types.Stocks.StateVector (StateVector, stateVector, total)
import Kalecky.Types.Stocks.Stock (Role (..), Stock, point, stock)
import Kalecky.Types.Units.IndexUnit (IndexBasis (..))
import Kalecky.Types.Units.LaborUnit (WorkerBasis (..))
import Kalecky.Types.Units.MoneyUnit (Denomination (..), MoneyBasis, moneyUnit)
import Kalecky.Types.Units.TimeUnit (TimeBasis (..))
import Kalecky.Types.Units.Unit (unit, value)

pop :: Natural -> Natural -> StateVector Region WorkerBasis
pop c p = fromJust (stateVector (\r -> unit Worker (if r == Central then c else p)) (unit Worker (c + p)))

capital :: Natural -> Natural -> Natural -> StateVector CapitalGroup (MoneyBasis COP)
capital f k mc =
  fromJust
    ( stateVector
        (\g -> fromJust (moneyUnit @COP Thousand ([f, k, mc] !! fromEnum g)))
        (fromJust (moneyUnit @COP Thousand (f + k + mc)))
    )

m1 :: Kalecky.Types.Panel.Period.Period
m1 = period Month 1

intensityTests :: TestTree
intensityTests =
  testGroup
    "Intensity"
    [ testGroup
        "laws"
        [ testProperty "total density is the Per of the totals" $
            \(c :: Natural) (p :: Natural) (f :: Natural) (k :: Natural) (mc :: Natural) ->
              (c + p > 0 && f + k + mc > 0) ==>
                let n = point m1 (pop c p) :: Stock Base Region WorkerBasis
                    kap = point m1 (capital f k mc) :: Stock Level CapitalGroup (MoneyBasis COP)
                    i = fromJust (intensity kap n)
                 in fmap densityValue (totalDensity m1 i)
                      == Just (toInteger (value (total (capital f k mc))) % toInteger (c + p))
        , testProperty "group densities sum to the total density" $
            \(c :: Natural) (p :: Natural) (f :: Natural) (k :: Natural) (mc :: Natural) ->
              (c + p > 0 && f + k + mc > 0) ==>
                let n = point m1 (pop c p) :: Stock Base Region WorkerBasis
                    kap = point m1 (capital f k mc) :: Stock Level CapitalGroup (MoneyBasis COP)
                    i = fromJust (intensity kap n)
                 in sum [densityValue (fromJust (groupDensity g m1 i)) | g <- [minBound .. maxBound]]
                      == densityValue (fromJust (totalDensity m1 i))
        , testProperty "matched densities exist for equal partitions and divide region by region" $
            \(c :: Natural) (p :: Natural) (c' :: Natural) (p' :: Natural) ->
              (c > 0 && p > 0 && c' > 0 && p' > 0) ==>
                let n = point m1 (pop c p) :: Stock Base Region WorkerBasis
                    l = point m1 (pop c' p') :: Stock Level Region WorkerBasis
                    i = fromJust (intensity l n)
                 in fmap densityValue (matchedDensity Central m1 i) == Just (toInteger c' % toInteger c)
        , testProperty "period mismatch is Nothing" $
            \(c :: Natural) (p :: Natural) ->
              c + p > 0 ==>
                let n = point (period Month 1) (pop c p) :: Stock Base Region WorkerBasis
                    l = point (period Month 2) (pop c p) :: Stock Level Region WorkerBasis
                 in isNothing (intensity l n)
        ]
    , testGroup
        "examples"
        [ testCase "K/N: 400 Thousand COP over 200 workers is exactly 2000 COP per worker" $ do
            let n = point m1 (pop 120 80) :: Stock Base Region WorkerBasis
                kap = point m1 (capital 100 250 50) :: Stock Level CapitalGroup (MoneyBasis COP)
            fmap densityValue (totalDensity m1 (fromJust (intensity kap n))) @?= Just 2000
        , testCase "A/N with a dimensionless index cancels to a plain density" $ do
            let n = point m1 (pop 120 80) :: Stock Base Region WorkerBasis
                a = point m1 (fromJust (stateVector (\(_ :: Region) -> unit Index 50) (unit Index 100))) :: Stock Level Region IndexBasis
            fmap densityValue (totalDensity m1 (fromJust (intensity a n))) @?= Just (1 % 2)
        ]
    ]
```

- [ ] **Step 2: Co-design gate.**

- [ ] **Step 3: RED skeleton + wiring**

```haskell
-- src/Kalecky/Operators/Intensity.hs
-- \[
--   \operatorname{Intensity} : \text{StateVector} \to \text{StateVector}
-- \]
-- \[
--   \begin{bmatrix} \frac{K}{N} \\ \frac{E}{N} \\ \cdots \end{bmatrix}
-- \]
-- \[ d = \frac{X}{B}, \qquad d_i = \frac{X_i}{B}, \qquad \sum_i d_i = d \]
-- \[ \frac{B}{X} \; \text{is not derivable} \]
module Kalecky.Operators.Intensity
  ( Density
  , densityRatio
  , densityValue
  , Intensity
  , intensity
  , totalDensity
  , groupDensity
  , matchedDensity
  ) where

import Data.Ratio ((%))

import Kalecky.Types.Panel.Period (Period)
import Kalecky.Types.Stocks.StateVector (component, total)
import Kalecky.Types.Stocks.Stock (Role (..), Stock, at, totals)
import Kalecky.Types.Units.CompoundUnit (Per, denominator, numerator, per)
import Kalecky.Types.Units.Unit (value)

newtype Density b c = Density (Per b c)
  deriving (Eq, Show)

densityRatio :: Density b c -> Per b c
densityRatio = undefined

densityValue :: Density b c -> Rational
densityValue = undefined

data Intensity g h b c = Intensity (Stock Level g b) (Stock Base h c)

intensity :: Stock Level g b -> Stock Base h c -> Maybe (Intensity g h b c)
intensity = undefined

totalDensity :: Period -> Intensity g h b c -> Maybe (Density b c)
totalDensity = undefined

groupDensity :: Ord g => g -> Period -> Intensity g h b c -> Maybe (Density b c)
groupDensity = undefined

matchedDensity :: Ord g => g -> Period -> Intensity g g b c -> Maybe (Density b c)
matchedDensity = undefined
```

- [ ] **Step 4: Verify RED** — `stack test` → `6 out of 146 tests failed`.

- [ ] **Step 5: Commit RED** — `git commit -m "test(kalecky): add approved Intensity and Density laws (RED)"`.

- [ ] **Step 6: Implement**

```haskell
densityRatio :: Density b c -> Per b c
densityRatio (Density r) = r

densityValue :: Density b c -> Rational
densityValue (Density r) =
  toInteger (value (numerator r)) % toInteger (value (denominator r))

intensity :: Stock Level g b -> Stock Base h c -> Maybe (Intensity g h b c)
intensity x b
  | map fst (totals x) == map fst (totals b) = Just (Intensity x b)
  | otherwise = Nothing

totalDensity :: Period -> Intensity g h b c -> Maybe (Density b c)
totalDensity p (Intensity x b) = do
  vx <- at p x
  vb <- at p b
  pure (Density (per (total vx) (total vb)))

groupDensity :: Ord g => g -> Period -> Intensity g h b c -> Maybe (Density b c)
groupDensity g p (Intensity x b) = do
  vx <- at p x
  vb <- at p b
  pure (Density (per (component g vx) (total vb)))

matchedDensity :: Ord g => g -> Period -> Intensity g g b c -> Maybe (Density b c)
matchedDensity g p (Intensity x b) = do
  vx <- at p x
  vb <- at p b
  pure (Density (per (component g vx) (component g vb)))
```

- [ ] **Step 7: Verify GREEN** — `stack test` → `All 146 tests passed`.

- [ ] **Step 8: Commit GREEN** — `git commit -m "feat(kalecky): implement intensity operator with Density cells (GREEN)"`.

---

### Task 8: Compile-fail boundary files

**Files:**
- Create: `test/should-fail/BaseInNumerator.hs`, `LevelAsBase.hs`, `PartitionMix.hs`, `GroupMix.hs`

**Interfaces:**
- Consumes: everything from Tasks 2–7. Checked by the existing `scripts/check-compile-fail.sh` (no change needed — it globs `test/should-fail/*.hs`).

- [ ] **Step 1: Write the four files**

```haskell
-- test/should-fail/BaseInNumerator.hs
-- MUST NOT TYPE-CHECK: a Base stock cannot be the numerator of an intensity.
{-# LANGUAGE DataKinds #-}
module BaseInNumerator where

import Kalecky.Operators.Intensity (Intensity, intensity)
import Kalecky.Types.Groups.Region (Region)
import Kalecky.Types.Stocks.Stock (Role (..), Stock)
import Kalecky.Types.Units.LaborUnit (WorkerBasis)

bad :: Stock Base Region WorkerBasis -> Stock Base Region WorkerBasis -> Maybe (Intensity Region Region WorkerBasis WorkerBasis)
bad n k = intensity n k
```

```haskell
-- test/should-fail/LevelAsBase.hs
-- MUST NOT TYPE-CHECK: a Level stock cannot be the denominator (the inverse is not derivable).
{-# LANGUAGE DataKinds #-}
module LevelAsBase where

import Kalecky.Operators.Intensity (Intensity, intensity)
import Kalecky.Types.Groups.Region (Region)
import Kalecky.Types.Stocks.Stock (Role (..), Stock)
import Kalecky.Types.Units.LaborUnit (WorkerBasis)

bad :: Stock Level Region WorkerBasis -> Stock Level Region WorkerBasis -> Maybe (Intensity Region Region WorkerBasis WorkerBasis)
bad k n = intensity k n
```

```haskell
-- test/should-fail/PartitionMix.hs
-- MUST NOT TYPE-CHECK: matched densities require the SAME partition on both sides.
{-# LANGUAGE DataKinds #-}
module PartitionMix where

import Kalecky.Operators.Intensity (Density, Intensity, matchedDensity)
import Kalecky.Types.Currency (Currency (..))
import Kalecky.Types.Groups.Capital (CapitalGroup (..))
import Kalecky.Types.Groups.Region (Region)
import Kalecky.Types.Panel.Period (Period)
import Kalecky.Types.Units.LaborUnit (WorkerBasis)
import Kalecky.Types.Units.MoneyUnit (MoneyBasis)

bad :: Period -> Intensity CapitalGroup Region (MoneyBasis COP) WorkerBasis -> Maybe (Density (MoneyBasis COP) WorkerBasis)
bad p i = matchedDensity KF p i
```

```haskell
-- test/should-fail/GroupMix.hs
-- MUST NOT TYPE-CHECK: a LaborGroup key cannot index a CapitalGroup state vector.
module GroupMix where

import Kalecky.Types.Currency (Currency (..))
import Kalecky.Types.Groups.Capital (CapitalGroup)
import Kalecky.Types.Groups.Labor (LaborGroup (..))
import Kalecky.Types.Stocks.StateVector (StateVector, component)
import Kalecky.Types.Units.MoneyUnit (MoneyBasis)
import Kalecky.Types.Units.Unit (Unit)

bad :: StateVector CapitalGroup (MoneyBasis COP) -> Unit (MoneyBasis COP)
bad v = component LF v
```

- [ ] **Step 2: Verify every file is rejected — and for the intended reason**

Run: `scripts/check-compile-fail.sh`
Expected: four new `ok:` lines (ten total), exit 0. Then spot-check the intended errors:

Run: `for f in BaseInNumerator LevelAsBase PartitionMix GroupMix; do printf ':load test/should-fail/%s.hs\n' "$f" | stack ghci kalecky-semantics:lib --ghci-options=-fno-code --silent 2>&1 | grep -A1 "error:" | head -2; done`
Expected: `Couldn't match type 'Base with 'Level` (×2), `Couldn't match type 'Region with 'CapitalGroup`, `Couldn't match type 'CapitalGroup with 'LaborGroup`. If any file fails for an *import* error instead, fix the import — an accidental rejection does not prove the boundary.

- [ ] **Step 3: Commit**

```bash
git add test/should-fail
git commit -m "test(kalecky): add compile-fail boundaries for stock roles and partitions"
```

---

### Task 9: Close out

**Files:**
- Modify: `README.md` (layout section), `src/TODO.md` (mark items delivered), `.planning/PROJECT.md` (Active → note delivered)

- [ ] **Step 1: Update README layout block** — add under `Types/`: `Groups/ (partition enums incl. Region)`, `Panel/ (Period, Panel)`, `Stocks/ (StateVector, Stock)`; under `Operators/`: `Intensity`. Add one line to "Status": "State vectors, stocks and intensity: see `docs/superpowers/specs/2026-08-16-state-vectors-and-intensity-design.md`."

- [ ] **Step 2: Annotate `src/TODO.md`** — prepend one line: `> Delivered 2026-08-xx per docs/superpowers/specs/2026-08-16-state-vectors-and-intensity-design.md — see src/Kalecky/Types/{Groups,Panel,Stocks} and Operators/Intensity.` Leave the math untouched.

- [ ] **Step 3: Full verification**

Run: `stack test 2>&1 | grep "tests passed" && scripts/check-compile-fail.sh | tail -1; echo "exit $?"`
Expected: `All 146 tests passed`, last line `ok: … ValuationMix.hs rejected …`, `exit 0`.

- [ ] **Step 4: Commit and push**

```bash
git add README.md src/TODO.md .planning/PROJECT.md
git commit -m "docs: record state vectors, stocks and intensity as delivered"
git push origin main
```

---

## Self-review notes

- Spec coverage: IndexBasis (T1), five group enums incl. regions-as-groups (T2), Period (T3), rectangular Panel + `window` (T4), reconciled StateVector + `share` (T5), role-tagged Stock + point/at/series/totals/toPanel (T6), intensity with three density views + `Density` (T7), four boundary files (T8), docs (T9). `Density` alias types (PerCapita etc.) are explicitly deferred in the spec.
- Deviation from spec, recorded: `point` takes an explicit `Period` (a one-column panel needs a column label); `stateVector` additionally requires `total > 0` so `share` is total.
- Type consistency checked across tasks: `Stock r g b` argument order (role, group, basis) is used identically in T6, T7, T8; `matchedDensity :: g -> Period -> …` matches T7's implementation and T8's `PartitionMix`.
