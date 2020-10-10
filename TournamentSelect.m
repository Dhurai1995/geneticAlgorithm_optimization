function iSelected = TournamentSelect(fitness, pTournament, tournamentSize)

populationSize = size(fitness,1);
i= 1:tournamentSize;
iTmp(i) = 1 + fix(rand*populationSize);

condition = true;
while(length(iTmp)>1 && condition)
    r = rand;
    if (r < pTournament)
        [~,iTmpMaximumLocation]=max(fitness(iTmp));
        iSelected = iTmp(iTmpMaximumLocation);
        condition=false;
    else
    [~,iTmpMaximumLocation]=max(fitness(iTmp));
        iTmp(iTmpMaximumLocation)=[];
    end
end
if length(iTmp)==1
    iSelected=iTmp(1);
end
end
