# Damsel 0.8
* removed deprecated functions
* removed old function names

# Damsel 0.7.1
* new Bioconductor style names for functions alongside original function names
* updated gene ontology plot

# Damsel 0.7.0
## New features
* updated gene ontology output of results
* gene ontology plot fn `plot_gene_ontology()`
* all functions operate case-insensitive - allow for .bam or .BAM and same with
dam or Dam
* replaced "Downreg" meth_status with "No_sig"
* new peak function available
* updates to plot functions - fixed wrap plot, set colours for count plot
* added new gene fn that uses a TxDb object or biomaRt (get_genes_biomaRt has been deprecated and will be removed)
* example count data available through data(dros_counts)

# Damsel 0.6.0
## Removed features
* removed process_bams_old as dependency `exomeCopy` has been deprecated.

# Damsel 0.5.0
## Removed features
* regions_gatc_drosophila_dm6 is no longer available as a data file upon loading. 
Can be made with `gatc_region_fn()`

# Damsel 0.4.0
## New features
* process_bams() new count method using `Rsubread::featureCounts()` allowing for fractional counts and differentiating between single and paired end BAM files
* edgeR_set_up() filter out large regions (> 10kb)
* aggregate_peaks() new method for ranking peaks based on theory of `csaw::getBestTest()`
* aggregate_peaks() retain small peaks so that they are able to be combined with the gaps fn
* gatc_track() simplified for one argument input - identifies if input is BSgenome or FASTA

## Bug fixes
* geom_genes can now handle a region of only introns - previously threw an error

# Damsel 0.3.1
## New features
* Plotting options - counts layout and log2 scale, and peak_id text
* New default for differential testing: p-value set to 0.01

# Damsel 0.3.0
## Bug fixes
* streamlined outputs
* removed obselete functions

# Damsel 0.2.0
## New features
* New peak output and functionality (combines peaks with small gaps)
* New genes output - with list of 3 data.frames
* Gene ontology fn 
* Plot_wrap() - plot all at once
* gatc_track() - create the GATC track

## Bug fixes
* accurate plotting

## Documentation
* runnable examples

# Damsel 0.1.0

* Added a `NEWS.md` file to track changes to the package.
* Added geom_genes.me allowing for genes plot
* Fixed geom_peak.new
