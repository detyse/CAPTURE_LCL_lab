# CAPTURE\_quickdemo Function Call Tree

This document outlines the main function calls made within `CAPTURE_quickdemo.m` and the subroutines they invoke. It is intended as a high level reference for understanding the flow of analysis in the demo.

## Top-Level Script

The entry point is the MATLAB function `CAPTURE_quickdemo` located at the repository root. Its purpose is to load preprocessed motion capture data, compute behavioral features, perform t-SNE embedding, cluster the resulting map, and visualize the behavior. The function signature is shown below:

```matlab
function [analysisstruct,hierarchystruct] = CAPTURE_quickdemo(inputfile,ratnames,coefficientfilename,linkname)
```

## Call Tree Overview

Below is a simplified call tree describing the main functions executed by `CAPTURE_quickdemo`. Arrows (`→`) indicate a function calling another function. Some helper routines and MATLAB built-ins (e.g. `tsne`, `pca`) are omitted for brevity but are noted where appropriate.

```
CAPTURE_quickdemo
├─ create_behavioral_features
│  ├─ compute_joint_angles_demo
│  ├─ compute_appendage_pc_demos
│  │  └─ (uses PCA and related helper functions)
│  └─ compute_wl_transform_features_demo
│     └─ (computes wavelet transform features)
├─ compute_tsne_features
│  └─ (normalizes features and builds analysisstruct)
├─ tsne (MATLAB builtin)
├─ compute_analysis_clusters_demo
│  ├─ cluster_tsne_maps
│  │  └─ findPointDensity (from MotionMapper)
│  ├─ find_cluster_velocities
│  └─ reorder_annotation
├─ plot_clustercolored_tsne
├─ animate_markers_nonaligned_fullmovie_demo
├─ animate_markers_aligned_fullmovie_demo
├─ create_extra_behavioral_features (optional)
│  └─ load_extra_tsne_features (optional)
└─ find_sequences_states_demo
```

The optional branches are executed only when the variable `ratname` equals `'myrat'`.

## Function Descriptions

### create_behavioral_features
Located at [`create_behavioral_features.m`](../create_behavioral_features.m). This routine calculates behavioral features from raw motion capture data. It sequentially calls:
- `compute_joint_angles_demo` — derives joint angle traces for different body segments.
- `compute_appendage_pc_demos` — performs PCA on joint angles and segment lengths to reduce dimensionality.
- `compute_wl_transform_features_demo` — computes wavelet-based dynamic features of the PCA components.

The resulting features are saved in `MLmatobj` for later use.

### compute_tsne_features
Defined in [`compute_tsne_features.m`](../compute_tsne_features.m). It gathers selected features from `MLmatobj`, normalizes them, and constructs an `analysisstruct` containing:
- Standardized feature matrix `jt_features`.
- Frame indices corresponding to valid tracking.
- Reduced versions of the mocap data for visualization.

### compute_analysis_clusters_demo
Found in [`Clustering/compute_analysis_clusters_demo.m`](../Clustering/compute_analysis_clusters_demo.m). It clusters the t-SNE points and organizes the annotation. Major subfunctions include:
- `cluster_tsne_maps` — builds density maps of the t-SNE embedding and applies watershed clustering.
- `find_cluster_velocities` — computes velocity traces for each cluster.
- `reorder_annotation` — reorders cluster labels for easier interpretation.

### plot_clustercolored_tsne
Implemented in [`Animating/plot_clustercolored_tsne.m`](../Animating/plot_clustercolored_tsne.m). Produces a colored scatter plot or density map of the t-SNE results, optionally drawing watershed boundaries.

### animate_markers_nonaligned_fullmovie_demo / animate_markers_aligned_fullmovie_demo
Visualization utilities located in the `Animating` folder. They generate frame-by-frame animations of the marker trajectories in either the raw or aligned coordinate system.

### create_extra_behavioral_features and load_extra_tsne_features (optional)
Additional routines in the `Behavioral_analysis` folder used when the example is run with `ratname` equal to `'myrat'`. They compute an extended set of 140 features and load them for t-SNE embedding.

### find_sequences_states_demo
Located at [`Behavioral_analysis/find_sequences_states_demo.m`](../Behavioral_analysis/find_sequences_states_demo.m). It performs higher-level sequence analysis on clustered behavior to identify structured sequences across multiple timescales.

### tsne
MATLAB built-in function used to compute the two-dimensional embedding of behavioral features.


## References in the Source Code

The main function and some of the helper calls can be viewed directly in the repository:
- [`CAPTURE_quickdemo.m`](../CAPTURE_quickdemo.m)
- [`compute_tsne_features.m`](../compute_tsne_features.m)
- [`Clustering/compute_analysis_clusters_demo.m`](../Clustering/compute_analysis_clusters_demo.m)
- [`Behavioral_analysis/find_sequences_states_demo.m`](../Behavioral_analysis/find_sequences_states_demo.m)

These files define the workflow that produces the behavioral maps and subsequent sequence analysis.
