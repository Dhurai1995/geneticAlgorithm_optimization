clear all;
clc
populationSize = 30;
numberOfGenes = 40;
crossoverProbability = 0.8;
mutationProbability = 0.025;
numberOfVariable =2;
tournamentSize=2 ;
nCopies = 2;
tournamentSelectionParameter = 0.75;
variableRange = 10.0;
numberOfGenerations = 100;
fitness = zeros(populationSize,1);

fitnessFigureHandle = figure;
hold on;
set(fitnessFigureHandle, 'Position', [50,50,500,200]);
set(fitnessFigureHandle, 'DoubleBuffer','on');
axis([1 numberOfGenerations 2.5 3]);
bestPlotHandle = plot(1:numberOfGenerations,zeros(1,numberOfGenerations));
textHandle = text(30,2.6,sprintf('best: %4.3f',0.0));
hold off;
drawnow;

surfaceFigureHandle = figure;
hold on;
set(surfaceFigureHandle, 'DoubleBuffer','on');
delta = 0.1;
limit = fix(2*variableRange/delta) + 1;
[xValues,yValues] = meshgrid(-variableRange:delta:variableRange,-variableRange:delta:variableRange);
zValues = zeros(limit,limit);
for j = 1:limit
    for k = 1:limit
        zValues(j,k) = EvaluateIndividual([xValues(j,k) yValues(j,k)]);
    end
end
surfl(xValues,yValues,zValues)
colormap gray;
shading interp;
view([-7 -9 10]);
decodedPopulation = zeros(populationSize,numberOfVariable);
populationPlotHandle = plot3(decodedPopulation(:,1),decodedPopulation(:,2),fitness(:),'kp');
hold off;
drawnow;

population = InitializePopulation(populationSize, numberOfGenes);

for iGeneration = 1:numberOfGenerations
    maximumFitness = 0.0; % Assumes non negative fitness values!
    xBest = zeros(1,2); % [0 0]
    bestIndividualIndex = 0;
    for i = 1:populationSize
        chromosome = population(i,:);
        x = DecodeChromosome(chromosome, variableRange,numberOfVariable);
        decodedPopulation(i,:) = x;
        fitness(i) = EvaluateIndividual(x);
        if (fitness(i) > maximumFitness)
            maximumFitness = fitness(i);
            bestIndividualIndex = i;
            xBest = x;
        end
    end
    
    
%     disp('xBest'); % Output suppressed. Retained for debugging.
%     disp(xBest);
%     disp('maximumFitness');
%     disp(maximumFitness);
%     
    tempPopulation = population;
    
    for i = 1:2:populationSize
        i1 = TournamentSelect(fitness,tournamentSelectionParameter,tournamentSize);
        i2 = TournamentSelect(fitness,tournamentSelectionParameter,tournamentSize);
        chromosome1 = population(i1,:);
        chromosome2 = population(i2,:);
        
        r = rand;
        if (r < crossoverProbability)
            newChromosomePair = Cross(chromosome1,chromosome2);
            tempPopulation(i,:) = newChromosomePair(1,:);
            tempPopulation(i+1,:) = newChromosomePair(2,:);
        else
            tempPopulation(i,:) = chromosome1;
            tempPopulation(i+1,:) = chromosome2;
        end
    end
    
    for i = 1:populationSize
        originalChromosome = tempPopulation(i,:);
        mutatedChromosome = Mutate(originalChromosome,mutationProbability);
        tempPopulation(i,:) = mutatedChromosome;
    end

    bestIndividual = population(bestIndividualIndex,:);
    modPopulation = InsertBestIndividual(tempPopulation,bestIndividual,nCopies);
    
    population = modPopulation;
    
    plotvector = get(bestPlotHandle,'YData');
    plotvector(iGeneration) = maximumFitness;
    set(bestPlotHandle,'YData',plotvector);
    set(textHandle,'String',sprintf('best: %4.3f',maximumFitness));
    set(populationPlotHandle,'XData',decodedPopulation(:,1),'YData', decodedPopulation(:,2),'ZData',fitness(:));
    drawnow;
end

format long;
disp('xBest');
disp(xBest);
disp('maximumFitness');
disp(maximumFitness);