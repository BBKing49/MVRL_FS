clear;
clc;

load(['mul_leavers.mat']);


view_nums = size(data,1);
num_cluster = max(labels);
[N,~] = size(data{1});
for v = 1:view_nums
    data{v} = mapminmax(data{v}',0,1)';
end
best_nmi = 0;
best_nmi1 = 0;
for lambda1 = 2.^(-5:0) % 正交参数
    for lambda2 = 2.^(-5:0) % 回归一致性约束参数
        for lambda3 = 2.^(-5:0) % 正则化参数
            for lambda4 = 2.^(-5:0) % 视角权重参数
                for rules = 3
                    option.lambda1 = lambda1;
                    option.lambda2 = lambda2;
                    option.lambda3 = lambda3;
                    option.lambda4 = lambda4;
                    option.rules = rules;
                    option.k = 7;
                    option.m = num_cluster;
                    option.Maxiter = 100;
                    
                    [common_rep,sepcifc_rep] = FL_MVRL(data,option);                    
                    
                    new_represent = common_rep;
                    for v = 1:view_nums
                        new_represent = [new_represent,sepcifc_rep{v}];
                    end

                    for f = 1:5                       
                        pred_labels = kmeans(new_represent,num_cluster,'maxiter',500,'replicates',20,'EmptyAction','singleton');
                        result_cluster = ClusteringMeasure(labels, pred_labels);
                        nmi(f) = result_cluster(2);
                        acc(f) = result_cluster(1);
                        purity(f) = result_cluster(3);
                    end
                    
                    if mean(nmi)>best_nmi
                        best_nmi = mean(nmi);
                        best_results.nmi = mean(nmi);
                        best_results.nmi_std = std(nmi);
                        best_results.acc = mean(acc);
                        best_results.acc_std = std(acc);
                        best_results.purity = mean(purity);
                        best_results.purity_std = std(purity);
                        fprintf('\n. acc=%.4f, nmi=%.4f, purity=%.4f ...\n', mean(acc),  mean(nmi), mean(purity));
                    end
                end
            end
        end
    end
end
