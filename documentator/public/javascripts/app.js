var app = (function(){
	"use strict";
	var app = angular.module("SearchApp",[]);
	var SearchCtrl = function($scope, $http, $location){
		console.log("this is the search controller");
		$scope.errorMsg, $scope.RETURN_STATUS
		$scope.items = null;
		$scope.page = null;
		$scope.pagination = [];
		
		function setUpController(){
			console.log("inside setup func");
			var params = $location.search();
			if(params['q']){
				$scope.query = params['q'];
				if(params['pg']){
					$scope.page = params['pg']
				}
				$scope.submitQuery(false);
			}
		}



		$scope.submitQuery = function(fromForm){
			console.log($scope.query);
			//formForm tells me that it was a new search so to set the page hash to 1
			if(fromForm){
				console.log("this is sent from the form");
				$scope.page = null;
				$location.search('pg', 1);
			}

			$scope.RETURN_STATUS, $scope.errorMsg = null;
			console.log("we have submitted a query");

			$location.search('q', $scope.query);

			
			var data = {
				"authenticity_token": $('meta[name="csrf-token"]').attr('content'),
				"query": $scope.query
			};

			if($scope.page !== null && $scope.page !== undefined){
				data['page'] = $scope.page
				$location.search('pg', $scope.page);
			}

			$http.post(BASE_URL + "/query", data).then(
				function(res){onSuccess(res)}, function(err){onError(err)});

		}

		$scope.showPage = function(p){
			$scope.page = p;
			$scope.current_page = p;
			
			$scope.submitQuery(false);
		}


		

		function onSuccess(res){
			console.log(res);
			if(res.data.total_count === 0){
				$scope.RETURN_STATUS = 0;
				$scope.items = []
				return;
			}

			$scope.items = res.data.items;
			console.log($scope.items.length);
			if( res.data.pagination.prev){
				var i = parseInt(res.data.pagination.prev);
				$scope.pagination.push(res.data.pagination.prev);
				$scope.current_page = i + 1;
			}else{
				var i = 1;
				$scope.current_page = 1;
			} 
			var limit = i + 5;
			$scope.pagination = [];
			$scope.last_page = res.data.pagination.last;
			

			for(i; i < res.data.pagination.last && i < limit; i++){
				
				$scope.pagination.push(i);
			}
			$scope.pagination.push(res.data.pagination.last);
			
			

		}

		function onError(res){
			$scope.RETURN_STATUS = -1;
			$scope.errorMsg = res.error;
			
		}

		setUpController();
		

		$scope.$on('$locationChangeSuccess', function(evt, newUrl, oldUrl){
			console.log("new url is " + newUrl);
			console.log($location.search());
			console.log("old url is " + oldUrl);
			if(newUrl !== oldUrl){
			//$scope.submitQuery();
				console.log("urls are the same!!!!");
				$location.replace();
				setUpController();
			}
		
		});
	}

	app.controller("SearchCtrl", SearchCtrl);
	return app;
})();