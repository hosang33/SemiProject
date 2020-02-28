package kr.pren.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;
import kr.pren.util.IbatisUtil;
import kr.pren.vo.SaleItem;
import kr.pren.vo.Steam;

public class SteamDao {
	private static SteamDao instance = new SteamDao();
	private SteamDao() {}
	public static  SteamDao getInstance() {
		return instance;
	}
	
	private SqlMapClient sqlmap = IbatisUtil.getSqlmap();
	
	
	// 찜 추가하기
	public void insertSteam (Steam steam) throws SQLException {
		sqlmap.insert("steams.insertSteam", steam);
	}
	
	// 찜 목록 전체조회하기
	@SuppressWarnings("unchecked")
	public List<Steam> getSteamList () throws SQLException {
		return sqlmap.queryForList("steams.getSteamList");
	}
	
	// 상품번호에 해당하는 추천수 조회
	public int getSteamCountByItemNo (int itemNo) throws SQLException {
		return (int) sqlmap.queryForObject("steams.getSteamCountByItemNo", itemNo);
	}
	
	// 유저번호에 해당하는 찜한 상품 삭제
	public void deleteSteam (Steam steam) throws SQLException {
		sqlmap.delete("steams.deleteSteam", steam);
	}
	// 아이템번호에 해당하는 찜삭제
	public void deleteSteamByItemNo(int itemNo) throws SQLException {
		sqlmap.delete("steams.deleteSteamByItemNo", itemNo);
	}
	
	// 로그인한유저번호와 상품번호에 해당하는 찜 상품 조회
	public int getSteamByuserNoAndItemNo (Steam steam) throws SQLException {
		return (int) sqlmap.queryForObject("steams.getSteamByuserNoAndItemNo", steam);
	}

}
