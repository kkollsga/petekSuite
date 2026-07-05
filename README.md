# petekSuite

**petekSuite** is the umbrella for a subsurface-modelling ecosystem: a small
family of Rust libraries (with Python bindings) that take raw subsurface data all
the way to static volumes and dynamic forecasts. The suite root itself builds no
code — it coordinates the peer libraries, keeps their seams coherent, and holds
the shared conventions ("the petek house style") that make them a family rather
than a monolith.

Dependencies flow **one direction, downward only** — no cycles, no sideways
sharing of code. Libraries share *conventions* freely and share *code* only
downward through the graph; each library stays usable standalone.

```
                          ┌─────────────────────────────────────────┐
   petekIO      DATA      │  ingest · normalize · validate ·         │
      │                   │  interpret → model-ready inputs          │
      ▼                   └─────────────────────────────────────────┘
   petekStatic  GEOMODEL   structural framework · grid · property
      │                    modelling · volumetrics + static uncertainty
      ▼
   petekSim     SIMULATION dynamic / engineering forecast · PVT ·
                           the `peteksim` Python product facade

   petekTools   TOOLKIT    horizontal · shared · domain-agnostic:
                           numeric kernels + units + container + viewer
                           (serves every layer)
```

## The libraries

### petekIO — the DATA layer
Ingests, normalizes, validates, and interprets subsurface data (wells, surfaces,
logs, seismic) into clean, **model-ready inputs**. A standalone Rust data-model +
IO library with optional PyO3 bindings — data only, no modelling framework.
Composes mature crates (`las_rs`, `geo`/`geozero`, `ndarray`, `rstar`,
`giga-segy`) behind its own IO traits.

### petekStatic — the GEOMODEL layer
Turns model-ready inputs into a populated **StaticModel**: the structural
framework (horizons + faults + zones), grid construction, and property modelling
(facies/petrophysics, geostatistics, trend population, log upscaling). It owns
**volumetrics + static uncertainty** — GRV / in-place volumes off the model
itself, Monte-Carlo over model realizations, and tornado analysis — producing a
StaticModel plus probabilistic (P90/P50/P10) curves.

### petekSim — the SIMULATION layer
Dynamic and engineering simulation: recoverable volumes and forecasting (decline,
p/z, material balance, and later full dynamic flow), plus PVT. It ships **the
product** — `peteksim`, the Python-facing appraisal toolkit that presents the
whole stack behind one façade.

### petekTools — the horizontal TOOLKIT
Domain-agnostic, shared numerics that serve every layer: the scattered-data
gridding / kriging / warm-start / geostatistics kernels Rust lacks, a units
system, the liftable container format, and a generic bundle viewer. A pure leaf —
it depends on none of the others; they build on it.

## Install

Packages are not yet published. The intended distribution is per-library, on both
crates.io (Rust) and PyPI (Python):

| Library      | cargo                    | pip                       | Status |
|--------------|--------------------------|---------------------------|--------|
| petekTools   | `cargo add petektools`   | `pip install petektools`  | coming |
| petekIO      | `cargo add petekio`      | `pip install petekio`     | coming |
| petekStatic  | `cargo add petekstatic`  | `pip install petekstatic` | coming |
| petekSim     | `cargo add peteksim`     | `pip install peteksim`    | coming |

## License

The suite is split by layer:

| Library      | License                                              |
|--------------|------------------------------------------------------|
| petekTools   | Apache-2.0                                            |
| petekIO      | Apache-2.0                                            |
| petekStatic  | Business Source License 1.1 (converts to Apache-2.0) |
| petekSim     | Business Source License 1.1 (converts to Apache-2.0) |

The horizontal toolkit and the data layer are permissively licensed (Apache-2.0).
The geomodel and simulation layers ship under the Business Source License 1.1,
each released version converting to Apache-2.0 on its change date. See each
library's own `LICENSE` / `NOTICE` for the authoritative terms.
