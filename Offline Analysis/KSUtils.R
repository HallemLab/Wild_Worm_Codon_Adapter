# utility functions used by the KS Distance article and supplementary markdown
#
# Packages used in this file. Actual library() calls are in the calling .Rmd file
#
# library(ggplot2)
# library(wrapr)
# library(rqdatatable)
# library(cdata)
# library(Matching)

# source = https://github.com/WinVector/Examples/blob/master/MonitoringForChangesInDistributions/KSUtils.R

###########################
#
# Functions to run permutation on two distributions
#
###########################

# Get the KS distance between two distributions
get_D = function(curr_dist, ref_dist) {
    # ks.test gets cranky when there are ties in the data
    # we are only using D, so ignore the warnings
    suppressWarnings(ks.test(curr_dist, ref_dist)$statistic)
}



#
# Run one iteration of the permutation test. Returns KS distance
# between the resampled sets.
#
# joint_dist: the current and reference data, concatenated
# n_curr: size of current data sample
# n_ref: size of reference data sample
#
permutation_run = function(joint_dist, n_curr, n_ref) {
    n = n_curr + n_ref
    ix = sample.int(n, size=n, replace=FALSE)
    ix_curr = ix[1:n_curr]
    ix_ref = ix[(n_curr+1):n]
    
    get_D(joint_dist[ix_curr], joint_dist[ix_ref])
    
}

#
# Run the entire permutation test.
# It's called "boot_" because I informally use the word "bootstrap"
# for both sample with and without replacement
#
# currdist: current data
# refdist: reference data
# nboots: number of iterations
#
# Returns a list of:
#  D_actual: KS distance between currdist and refdist
#  D_threshold: Threshold from bootstrapping
#  D_dist: vector of distances from all bootstrapped iterations
#
boot_dist_compare = function(currdist, refdist, nboots) {
    ncurr = length(currdist)
    nref = length(refdist)
    jointdist = c(currdist, refdist)
    
    D_dist = vapply(1:nboots,
                    function(i) permutation_run(jointdist, ncurr, nref),
                    numeric(1))
    
    D_actual = get_D(currdist, refdist)
    
    p_est = sum(D_dist >= D_actual)/nboots
    
    
    as_named_list(D_actual, D_dist, p_est)
    
}



#
# Display the distribution of bootstrapped distances,
# compare it to the actual KS distance, and
# report whether or not it is greater than the threshold
#
# dcompare: output of boot_dist_compare()
#
display_dist_compare = function(dcompare, pthresh = 0.002, title="") {
    unpack(dcompare, D_actual, D_dist, p_est)
    mesg = paste0("D = ", format(D_actual, digits=3),
                  "\n estimated p = ", format(p_est, digits=3), "\n")
    
    if(p_est <= pthresh) {
        mesg = paste(mesg, "-- distributions appear different")
    } else {
        mesg = paste(mesg, "-- distributions do not appear different")
    }
    (ggplot(data.frame(D=D_dist), aes(x=D)) +
              geom_density(adjust=0.5) +
              geom_vline(xintercept = D_actual,
                         color="maroon", linetype=2) +
              labs(x = "KS Statisic (D)") +
              theme_bw() +
              theme(plot.title.position = "panel",
                    plot.caption.position = "panel",
                    plot.title = element_text(face = "bold",
                                              size = 8, hjust = 0),
                    plot.subtitle = element_text(size = 8),
                    legend.title = element_text(size = 8),
                    axis.title = element_text(size = 8),
                    axis.text = element_text(size = 8)) +
              ggtitle(title, subtitle=mesg))
}