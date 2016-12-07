function normalized=normalizePopulation(unnormalized,lb,ub)
    normalized = (unnormalized - lb) ./ (ub - lb);
end