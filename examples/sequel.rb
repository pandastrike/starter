require "sequel"

module DatasetMixins
  def time_range(column, begin_time, end_time)
    ds = self;
    if begin_time
      ds = ds.filter(column >= begin_time)
    end
    if end_time
      ds = ds.filter(column < end_time)
    end
    ds
  end

  def updated_range(*args)
    time_range(:updated_at, *args)
  end

  def created_range(*args)
    time_range(:created_at, *args)
  end

  def created_by(dataset)
    filter(:user_id => dataset.select(:id))
  end

end

Sequel::Dataset.send(:include, DatasetMixins)
Sequel::Model.send(:extend, DatasetMixins)
