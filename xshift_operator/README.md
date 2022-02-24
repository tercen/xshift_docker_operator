# Xshift operator

#### Description
`Xshift` operator performs a fast clustering by automatic search and find of density peaks

##### Usage
Input projection|.
---|---
`row`   | represents the variables (e.g. channels, markers)
`col`   | represents the observations (e.g. cells, samples, individuals) 
`y-axis`| is the measurement value


Input parameters|.
---|---
`num_nearest_neighbors`      | Optional parameter num_nearest_neighbors is defining the resolution of density estimate and hence indirectly controls the number of clusters. If omitted, the clustering will run with the default setting of K=20. Keeping this default setting is recommended for the first pass because the runtime will be fast and the result is likely to be close to the optimal. Setiing the parameter to 'auto' instead of will lead to the algorithm running through an automatically determined range of K values and then selecting the optimal clustering via the elbow method.
`transformation`             | numerical transformation is essential to ensure that the expression values on each channel are approximately normally distributed, Options:"NONE", "ASINH", "DOUBLE_ASINH". Default: "ASINH".
`scaling_factor`             | a factor by which each value gets divided before transformation. 5 is default, but could be set to 3 or lower in order to improve cluster separation on low-intensity channels.
`noise_threshold`            | a specified noise threshold will be subtracted from every raw value and then all the negative values will be set to zero. This filters out low-lever noise and GREATLY improves clustering in many dimensions, default 1.0
`euclidian_length_threshold` | setting this limit above 0 excludes events that have low intensity on all channels (unstained cells), default 0.0
`rescale`                    | rescaling of clustering channels may help equalizing the extent to which high- and low-expressed markers influence clustering. Options: "NONE", "SD" or "QUANTILE". Default "NONE".
`quantile`                   | if quantile rescaling is selected, a quantile on which the rescaling is based should be specified here, default 0.95
`rescale_separately`         | rescaling each file separately may help equalizing the variance between runs, default "false". 

Output relations|.
---|---
`cluster_id`| character, returns a cluster id per column (e.g. per cell)

##### Details
`Xshift` operator performs the clustering using the [Vortex app](https://github.com/nolanlab/vortex)

#### References
see  https://github.com/nolanlab/vortex/wiki/Getting-Started

##### See Also

#### Examples
