package org.cloud.ssm.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.cloud.ssm.entity.Employee;
import org.cloud.ssm.utils.BaseMapper;

public interface EmployeeMapper extends BaseMapper<Employee> {

    List<Employee> selectAllByCondition(@Param("name") String name, @Param("departmentName") String departmentName);

    Long selectCountByCondition(@Param("name") String name, @Param("departmentName") String departmentName);
}
