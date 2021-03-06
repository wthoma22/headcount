require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  attr_reader :er, :repo

  def setup
    file_1 = "./data/Kindergartners in full-day program.csv"
    file_2 = "./data/High school graduation rates.csv"

    @er = EnrollmentRepository.new
    er.load_data({:enrollment => {:kindergarten => file_1}})

    @repo = EnrollmentRepository.new
    repo.load_data({:enrollment => {
      :kindergarten => file_1, :high_school_graduation => file_2}})
  end

  def test_it_exists
    assert_instance_of EnrollmentRepository, er
  end

  def test_find_name
    er_name = "ACADEMY 20"
    result = er.find_by_name(er_name)
    assert_instance_of Enrollment, result
  end

  def test_get_enrollment_participation
    er_name = "ACADEMY 20"
    enrollment = er.find_by_name(er_name)
    participation_by_year = {
      2007=>0.391, 2006=>0.353, 2005=>0.267, 2004=>0.302, 2008=>0.384,
      2009=>0.39, 2010=>0.436, 2011=>0.489, 2012=>0.478, 2013=>0.487,
      2014=>0.49
    }
    assert_equal participation_by_year, enrollment.kindergarten_participation_by_year
  end

  def test_get_enrollment_participation_in_single_year
    er_name = "JEFFERSON COUNTY R-1"
    enrollment = er.find_by_name(er_name)
    result = enrollment.kindergarten_participation_in_year(2012)
    assert_equal 0.728, result
  end

  def test_load_two_files
    enrollment = repo.find_by_name("JEFFERSON COUNTY R-1")
    assert_instance_of Enrollment, enrollment
  end

  def test_get_graduation_rate_all_years
    enrollment = repo.find_by_name("ACADEMY 20")
    expected = {
      2010 => 0.895,
      2011 => 0.895,
      2012 => 0.889,
      2013 => 0.913,
      2014 => 0.898,
     }
     assert_equal expected, enrollment.graduation_rate_by_year
  end

  def test_get_graduation_rate_in_year
    enrollment = repo.find_by_name("ACADEMY 20")
    assert_equal 0.895, enrollment.graduation_rate_in_year(2010)
  end
end
