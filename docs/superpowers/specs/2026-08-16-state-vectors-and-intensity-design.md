# State Vectors, Stocks and Intensity — Design

**Date:** 2026-08-16 · **Source:** `src/TODO.md` (items 2+) · **Status:** approved in brainstorming, awaiting spec review

## Purpose

Add reconciled, partition-indexed stock panels to the kernel so that quantities decomposed by income-receiving group (and by region) can be expressed, checked, and turned into densities such as K/N — the raw material of the ψ functional-distribution matrix. Everything builds on the v1.0 kernel: cells are kernel `Unit b` values, ratios are kernel `Per` compounds, and the compile-time boundary extends to panels unchanged.

## Decisions (from the brainstorm)

| Decision | Choice |
|---|---|
| Groups | Per-stock partition enums, one file each; **regions are a group enum too** |
| Reconciliation | Rule (b): observed total is data; components must sum to it exactly (after alignment); constructor is `Maybe` |
| Panel shape | Rectangular panels; ragged source data handled only by a `window` loader before construction |
| Time index | `Period = granularity (TimeBasis) + ordinal`; ordering only within a granularity |
| Cells | Kernel units (`Unit b`); technology `A` via new dimensionless `IndexBasis` |
| Intensity base | Any stock constructed with role `Base`; denominator must be `Base` (type-enforced); numerator `Level` |
| Cell name | `Density b c` — quantity of `b` per unit of base `c` |
| Comments | Each new module's comments are ONLY the TODO's math in `\[ … \]` notation |

## Module placement (tree is design; one concept per file)

```
src/Kalecky/Types/
├── Units/IndexUnit.hs        data IndexBasis = Index ; scaleOf Index = s(1,1)
├── Groups/Population.hs      data PopulationGroup = NK | NF | NLI | NL | NML
├── Groups/Capital.hs         data CapitalGroup    = KF | KK | KMC        (MC: land rental)
├── Groups/Labor.hs           data LaborGroup      = LI | LF | LML
├── Groups/Education.hs       data EducationGroup  = EPublic | EPrivate
├── Groups/Region.hs          data Region = …   OPEN INPUT: the user supplies the region list before implementation
├── Panel/Period.hs           Period, next, ordering within granularity
├── Panel/Panel.hs            Panel g t v — economics-free rectangular map with queries
├── Stocks/StateVector.hs     StateVector g b + reconciling constructor + share
└── Stocks/Stock.hs           Stock (r :: Role) g b — period-indexed StateVectors, role-tagged
src/Kalecky/Operators/Intensity.hs   intensity, Intensity g h b c, Density b c
```

All group enums derive `Eq, Ord, Show, Enum, Bounded`. Group constructors carry the stock letter (`KF`, `LF`) so values of different partitions can never be confused.

## Types and API

### Period
```haskell
data Period = Period TimeBasis Natural          -- granularity, ordinal; ctor hidden
period   :: TimeBasis -> Natural -> Period
next     :: Period -> Period
compareP :: Period -> Period -> Maybe Ordering  -- Nothing across granularities
```

### Panel (economics-free)
```haskell
data Panel g t v                                 -- rectangular; ctor hidden
panel  :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> (g -> t -> v) -> Panel g t v
window :: (Bounded g, Enum g, Ord g, Ord t) => [t] -> [(g, t, v)] -> Maybe (Panel g t v)
  -- the ONLY ragged-aware function: Just iff every (group, period) in the requested
  -- period list is present exactly once; observations outside the list are ignored
cell   :: g -> t -> Panel g t v -> Maybe v       -- Nothing only for unknown t
row    :: g -> Panel g t v -> [(t, v)]
column :: t -> Panel g t v -> Maybe (g -> v)
groups, periods
```
A single data point is a one-column (and, if undecomposed, one-row) panel.

### StateVector
```haskell
data StateVector g b                              -- ctor hidden
stateVector :: (Bounded g, Enum g, Ord g) => (g -> Unit b) -> Unit b -> Maybe (StateVector g b)
  -- aligns all operands exactly; Just iff Σ value(component) == value(total)
component :: g -> StateVector g b -> Unit b
total     :: StateVector g b -> Unit b
share     :: g -> StateVector g b -> Rational       -- Σ shares == 1 exactly
```

### Stock
```haskell
data Role = Base | Level                           -- promoted
data Stock (r :: Role) g b                         -- Panel g Period (Unit b), every column a valid StateVector; ctor hidden
stock  :: [(Period, StateVector g b)] -> Maybe (Stock r g b)   -- Nothing: repeated / mixed-granularity / non-contiguous periods
point  :: StateVector g b -> Stock r g b
at     :: Period -> Stock r g b -> Maybe (StateVector g b)
series :: g -> Stock r g b -> [(Period, Unit b)]
totals :: Stock r g b -> [(Period, Unit b)]
```
Role is fixed at construction; using a stock as both base and level means two constructions.

### Intensity
```haskell
newtype Density b c = Density (Per b c)            -- quantity of b per unit of base c
data Intensity g h b c                              -- three views over a shared period range:
intensity :: Stock Level g b -> Stock Base h c -> Maybe (Intensity g h b c)   -- Nothing on period mismatch
totalDensity   :: Period -> Intensity g h b c -> Maybe (Density b c)          -- total/total
groupDensity   :: g -> Period -> Intensity g h b c -> Maybe (Density b c)     -- numerator group / base total
matchedDensity :: Period -> g -> Intensity g g b c -> Maybe (Density b c)     -- only when g ~ h
```
The ordering rule (no inverse) is the signature: only a `Base` stock can be the second argument.

## Data flow

raw observations → `window` (coverage) → `stateVector` per period (reconciliation) → `stock @Role` (sequence validity) → `intensity` (densities as `Per`) → later: ψ shares from `share`.

## Errors

All partiality is `Maybe`, at construction, for economically real reasons only: unreconciled totals, cross-granularity periods, non-contiguous/duplicate periods, period mismatch between stocks, incomplete coverage windows. Cell queries on built panels are total except for unknown periods. Everything type-level (role, partition, dimension) is a compile error.

## Testing

Laws (QuickCheck) + examples per module, RED→GREEN pairs, user-approved before implementation:
- Period: within-granularity total order; `next` strictly increasing; cross-granularity `Nothing`.
- Panel: rectangular ⇒ `cell` total on known periods; row/column round-trip; point panel has one cell.
- StateVector: `Just` iff exact sum equality after alignment; shares sum to 1; Thousand-vs-Raw inputs reconcile.
- Stock: rejects repeated/mixed/non-contiguous periods; every `at` column valid; `point` is one period.
- Intensity: total density == Per of totals; group densities sum to total density; matched densities iff same partition; period mismatch `Nothing`.

Examples: `N` by PopulationGroup (reconciles / off-by-one fails); `K = K_F ⊕ K_K ⊕ K_MC` Thousand-COP vs Raw total; `K/N` money per worker exact; `A/N` cancels to dimensionless.

Compile-fail (`test/should-fail/`): `BaseInNumerator.hs`, `LevelAsBase.hs`, `PartitionMix.hs`, `GroupMix.hs`.

## Out of scope

The ψ matrix itself, Elasticity/Distributional refinements, RealWage — unchanged v2 backlog. No data loaders beyond `window`'s contract.
