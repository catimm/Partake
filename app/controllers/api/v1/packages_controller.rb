class Api::V1::PackagesController < ApplicationController
  def index
    @package_instances = PackageInstance.all
  end
end
