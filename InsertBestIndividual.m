function modPopulation = InsertBestIndividual(tempPopulation,bestIndividual,nCopies)

for i=1:nCopies
    tempPopulation(i,:) = bestIndividual;
end
modPopulation = tempPopulation;
end

