var app = (function(){
	"use strict";
	var app = angular.module("SearchApp",[]);
	var SearchCtrl = function($scope, $http, $location){
		console.log("this is the search controller");
		$scope.errorMsg, $scope.RETURN_STATUS
		$scope.items = null;
		$scope.page = null;




		$scope.submitQuery = function(){
			console.log($scope.query);
			$scope.RETURN_STATUS, $scope.errorMsg = null;
			console.log("we have submitted a query");

			$location.search('q', $scope.query);
			if($scope.page !== null && $scope.page !== undefined) 
				$location.search('pg', $scope.page);
			var data = {
				"authenticity_token": $('meta[name="csrf-token"]').attr('content'),
				"query": $scope.query
			};

			if($scope.page !== null && $scope.page !== undefined){
				data['page'] = $scope.page
			}

			$http.post(BASE_URL + "/query", data).then(
				function(res){onSuccess(res)}, function(err){onError(err)});

		}

		$scope.showPage = function(p){
			$scope.page = p;
			$scope.current_page = p;
			$scope.submitQuery();
		}


		var params = $location.search();
		if(params['q']){
			$scope.query = params['q'];
			if(params['page']){
				$scope.page = params['page']
			}
			$scope.submitQuery();
		}

		function onSuccess(res){
			console.log(res);
			if(res.data.total_count === 0){
				$scope.RETURN_STATUS = 0;
				$scope.items = []
				return;
			}

			$scope.items = res.data.items;
			if( res.data.pagination.prev){
				var i = res.data.pagination.prev;
				$scope.pagination.push(res.data.pagination.prev);
				$scope.current_page = i + 1;
			}else{
				var i = 1;
			} 
			var limit = i + 5;
			$scope.pagination = [];
			$scope.last_page = res.data.pagination.last;
			

			for(i; i < res.data.pagination.last && i < limit; i++){
				
				$scope.pagination.push(i);
			}
			$scope.pagination.push(res.data.pagination.last);
			console.log($scope.pagination);
			return;

		}

		function onError(res){
			$scope.RETURN_STATUS = -1;
			$scope.errorMsg = res.error;
			return;
		}
	}

	app.controller("SearchCtrl", SearchCtrl);
	return app;
})();