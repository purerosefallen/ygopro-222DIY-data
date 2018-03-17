--
Nef = Nef or {}
local os = require("os")
-- require "nef/cardList"
function Nef.unpack(t, i)
    i = i or 1
    if t[i] then
       return t[i], Nef.unpack(t, i + 1)
    end
end

function Nef.unpackOneMember(t, member, i)
    i = i or 1
    if t[i] and t[i][member] then
       return t[i][member], Nef.unpackOneMember(t, member, i+1)
    end
end

function Nef.AddSynchroProcedureWithDesc(c,f1,f2,ct,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetDescription(desc)
	e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
	e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
	e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	return e1
end

function Nef.AddRitualProcEqual(c,filter,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Auxiliary.RPETarget(filter))
	e1:SetOperation(Auxiliary.RPEOperation(filter))
	e1:SetDescription(desc)
	c:RegisterEffect(e1)
	return e1
end

function Nef.AddXyzProcedureWithDesc(c,f,lv,ct,desc,maxct,alterf,op)
	if c.xyz_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if f then
			mt.xyz_filter=function(mc) return f(mc) and mc:IsXyzLevel(c,lv) end
		else
			mt.xyz_filter=function(mc) return mc:IsXyzLevel(c,lv) end
		end
		mt.xyz_count=ct
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetDescription(desc)
	if not maxct then maxct=ct end
	if alterf then
		e1:SetCondition(Auxiliary.XyzCondition2(f,lv,ct,maxct,alterf,desc,op))
		e1:SetTarget(Auxiliary.XyzTarget2(f,lv,ct,maxct,alterf,desc,op))
		e1:SetOperation(Auxiliary.XyzOperation2(f,lv,ct,maxct,alterf,desc,op))
	else
		e1:SetCondition(Auxiliary.XyzCondition(f,lv,ct,maxct))
		e1:SetTarget(Auxiliary.XyzTarget(f,lv,ct,maxct))
		e1:SetOperation(Auxiliary.XyzOperation(f,lv,ct,maxct))
	end
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	return e1
end

function Auxiliary.EnablePendulumAttribute(c,reg)
	local argTable = {1}
	return Nef.EnablePendulumAttributeSP(c,99,Auxiliary.TRUE,argTable,reg,nil)
end

function Nef.GetExtraPendulumEffect(c, code, count)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(count or 1, code or 10000000)
	e1:SetCondition(Nef.PendConditionSP())
	e1:SetOperation(Nef.PendOperationSP())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	return e1
end

function Nef.EnablePendulumAttributeSP(c,num,filter,argTable,reg,tag)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local mlist={}
	mlist.pend_filter=filter
	mlist.pend_arg=argTable
	mlist.pend_num=num
	mlist.pend_tag=tag
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(10000001)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetValue(Nef.order_table_new(mlist))
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1, 10000000)
	e1:SetCondition(Nef.PendConditionSP())
	e1:SetOperation(Nef.PendOperationSP())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)

	-- 由于utility处加载nef，不需要再无效效果
	-- --disable HINTMSG_SPSUMMON 
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetType(EFFECT_TYPE_FIELD)
	-- e2:SetRange(LOCATION_PZONE)
	-- e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	-- e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	-- e2:SetTargetRange(1,0)
	-- e2:SetTarget(Nef.PendSummonLimitTarget)
	-- c:RegisterEffect(e2)

	--register by default
	if reg==nil or reg then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(1160)
		e3:SetType(EFFECT_TYPE_ACTIVATE)
		e3:SetCode(EVENT_FREE_CHAIN)
		c:RegisterEffect(e3)
	end

	mt.pend_effect1 = e1
	--mt.pend_effect2 = e2
end

function Nef.PendSummonCheck(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpc,rpc)
	local eset1={lpc:IsHasEffect(10000001)}
	local eset2={rpc:IsHasEffect(10000001)}
	if c:IsType(TYPE_RITUAL) then
		for _,te in ipairs(eset1) do
			local mt=Nef.order_table[te:GetValue()]
			if mt.pend_tag and mt.pend_tag:find("GodSprite") then
				return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,false)
			end
		end
		for _,te in ipairs(eset2) do
			local mt=Nef.order_table[te:GetValue()]
			if mt.pend_tag and mt.pend_tag:find("GodSprite") then
				return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,false)
			end
		end
	end
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end

function Nef.PConditionFilterSP(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpz,rpz)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local normalCondition = (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and not c:IsForbidden()
		and Nef.PendSummonCheck(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpz,rpz) 
	local spCondition = filter(c,Nef.unpack(argTable)) and filter2(c,Nef.unpack(argTable2))
	return spCondition and normalCondition
end

function Nef.PConditionFilterSP2(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpz,rpz)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local normalCondition = lv>lscale and lv<rscale and not c:IsForbidden()
		and Nef.PendSummonCheck(c,e,tp,lscale,rscale,filter,argTable,filter2,argTable2,lpz,rpz)
	local spCondition = filter(c,Nef.unpack(argTable)) and filter2(c,Nef.unpack(argTable2))
	return spCondition and normalCondition
end

function Nef.PendConditionSP()
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()

				local lpz=Duel.GetFieldCard(tp, LOCATION_PZONE, 0)
				local rpz=Duel.GetFieldCard(tp, LOCATION_PZONE, 1)
				if not (lpz and rpz) then return false end

				local n1, filter1, argTable1, tag1, pexfunc1 = Nef.GetPendSPInfo(lpz)
				local n2, filter2, argTable2, tag2, pexfunc2 = Nef.GetPendSPInfo(rpz)

				local lscale=lpz:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end

				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				if ft<=0 then return false end

				if n1 == 0 or n2 == 0 then return end

				if pexfunc1 and pexfunc1(lpz):IsExists(Nef.PConditionFilterSP2,1,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz) then
					return true
				end
				if pexfunc2 and pexfunc2(rpz):IsExists(Nef.PConditionFilterSP2,1,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz) then
					return true
				end

				local loc = 0
				if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then loc = loc + LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp) > 0 then loc = loc + LOCATION_EXTRA end
				if loc == 0 then return false end

				local g = nil
				if og then
					g = og:Filter(Card.IsLocation, nil, loc)
					return g:IsExists(Nef.PConditionFilterSP,1,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
				else
					return Duel.IsExistingMatchingCard(Nef.PConditionFilterSP,tp,loc,0,1,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
				end
			end
end

function Nef.PendOperationSP()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local lpz = Duel.GetFieldCard(tp, LOCATION_PZONE, 0)
				local rpz = Duel.GetFieldCard(tp, LOCATION_PZONE, 1)

				local n1, filter1, argTable1, tag1, pexfunc1 = Nef.GetPendSPInfo(lpz)
				local n2, filter2, argTable2, tag2, pexfunc2 = Nef.GetPendSPInfo(rpz)
				
				local lscale = lpz:GetLeftScale()
				local rscale = rpz:GetRightScale()
				if lscale > rscale then lscale, rscale = rscale, lscale end

				local ft1 = Duel.GetLocationCount(tp, LOCATION_MZONE)
				local ft2 = Duel.GetLocationCountFromEx(tp)
				local ft = Duel.GetUsableMZoneCount(tp)
				if Duel.IsPlayerAffectedByEffect(tp, 59822133) then
					if ft1 > 0 then ft1 = 1 end
					if ft2 > 0 then ft2 = 1 end
					ft = 1
				end
				ft = math.min(ft, n1, n2)

				local loc = 0
				if ft1 > 0 then loc = loc + LOCATION_HAND end
				if ft2 > 0 then loc = loc + LOCATION_EXTRA end

				local exg = Group.CreateGroup()
				if pexfunc1 then exg:Merge(pexfunc1(lpz)) end
				if pexfunc2 then exg:Merge(pexfunc2(rpz)) end

				local tg = nil
				if og then
					tg=exg:Filter(Nef.PConditionFilterSP2,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					local g2=og:Filter(Card.IsLocation,nil,loc):Filter(Nef.PConditionFilterSP,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					tg:Merge(g2)
				else
					tg=exg:Filter(Nef.PConditionFilterSP2,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					local g2=Duel.GetFieldGroup(tp,loc,0):Filter(Nef.PConditionFilterSP,nil,e,tp,lscale,rscale,filter1,argTable1,filter2,argTable2,lpz,rpz)
					tg:Merge(g2)
				end

				ft1 = math.min(ft1, tg:FilterCount(Card.IsLocation, nil, 0x3ff-LOCATION_EXTRA))
				ft2 = math.min(ft2, tg:FilterCount(Card.IsLocation, nil, LOCATION_EXTRA))

				local ect = c29724053 and Duel.IsPlayerAffectedByEffect(tp, 29724053) and c29724053[tp]
				if ect and ect < ft2 then ft2 = ect end

				while true do
					local ct1 = tg:FilterCount(Card.IsLocation, nil, 0x3ff-LOCATION_EXTRA)
					local ct2 = tg:FilterCount(Card.IsLocation, nil, LOCATION_EXTRA)
					local ct = ft
					if ct1 > ft1 then ct = math.min(ct, ft1) end
					if ct2 > ft2 then ct = math.min(ct, ft2) end
					if ct <= 0 then break end
					if sg:GetCount() > 0 and not Duel.SelectYesNo(tp, 210) then ft = 0 break end
					Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
					local g = tg:Select(tp, 1, ct, nil)
					tg:Sub(g)
					sg:Merge(g)
					if g:GetCount() < ct then ft = 0 break end
					ft = ft - g:GetCount()
					ft1 = ft1 - g:FilterCount(Card.IsLocation, nil, 0x3ff-LOCATION_EXTRA)
					ft2 = ft2 - g:FilterCount(Card.IsLocation, nil, LOCATION_EXTRA)
				end

				if ft > 0 then
					local tg1 = tg:Filter(Card.IsLocation, nil, 0x3ff-LOCATION_EXTRA)
					local tg2 = tg:Filter(Card.IsLocation, nil, LOCATION_EXTRA)
					if ft1 > 0 and ft2 == 0 and tg1:GetCount() > 0 and (sg:GetCount() == 0 or Duel.SelectYesNo(tp, 210)) then
						local ct = math.min(ft1, ft)
						Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
						local g = tg1:Select(tp, 1, ct, nil)
						sg:Merge(g)
					end
					if ft1 == 0 and ft2 > 0 and tg2:GetCount() > 0 and (sg:GetCount() == 0 or Duel.SelectYesNo(tp, 210)) then
						local ct = math.min(ft2, ft)
						Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
						local g = tg2:Select(tp, 1, ct, nil)
						sg:Merge(g)
					end
				end

				Duel.HintSelection(Group.FromCards(lpz))
				Duel.HintSelection(Group.FromCards(rpz))
			end
end

function Nef.SetPendMaxNum(c, num, reset_flag, property, reset_count)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(10000002)
	local property=property or 0
	e1:SetProperty(bit.bor(property,EFFECT_FLAG_CANNOT_DISABLE))
	e1:SetValue(num)
	if reset_flag then
		e1:SetReset(reset_flag,reset_count)
	end
	c:RegisterEffect(e1,true)
end

function Nef.SetPendExTarget(c, filter_func)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(10000003)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetValue(filter_func)
	c:RegisterEffect(e2)
end

function Nef.GetPendMaxNum(c)
	local ret=0
	local eset={c:IsHasEffect(10000002)}
	for _,te in ipairs(eset) do
		local v=te:GetValue()
		if v and type(v)=="number" then ret=math.max(ret,v) end
	end
	return ret
end

function Nef.GetPendSPInfo(c)
	local eset={c:IsHasEffect(10000001)}
	local eset_ex={c:IsHasEffect(10000003)}
	local pend_num = 99
	local pend_filter = Auxiliary.TRUE
	local pend_arg = {1}
	local pend_tag = ""
	local pend_extra_func = Group.CreateGroup
	for _,te in ipairs(eset) do
		local mt=Nef.order_table[te:GetValue()]
		if mt then
			if mt.pend_num then
				local pnum = type(mt.pend_num) == "number" and mt.pend_num or mt.pend_num(c)
				pend_num = math.min(pend_num, pnum)
			end
			if mt.pend_filter then				
				local f1=pend_filter
				local arg=mt.pend_arg or {1}
				local f2_ori=mt.pend_filter
				local f2=function(c)
					return not f2_ori or f2_ori(c,table.unpack(arg))
				end
				pend_filter=function(c) return f1(c) and f2(c) end
			end
			pend_arg=mt.pend_arg or pend_arg
			pend_tag=mt.pend_tag and pend_tag..mt.pend_tag or pend_tag
		end
	end
	for _,te in ipairs(eset_ex) do
		local f=te:GetValue()
		local oldf=pend_extra_func
		pend_extra_func=function(...)
			local g=oldf(...)
			g:Merge(f(...))
			return g
		end
	end
	local max_pend_num = Nef.GetPendMaxNum(c)
	if max_pend_num>0 then pend_num = math.min(pend_num,max_pend_num) end
	return pend_num, pend_filter, pend_arg, pend_tag, pend_extra_func
end

function Nef.GetFieldLeftScale(tp)
	local lpz=Duel.GetFieldCard(tp, LOCATION_PZONE, 0)
	if lpz then 
		return lpz:GetLeftScale()
	else
		return
	end
end

function Nef.GetFieldRightScale(tp)
	local rpz=Duel.GetFieldCard(tp, LOCATION_PZONE, 1)
	if rpz then 
		return rpz:GetRightScale()
	else
		return
	end
end

-- function Nef.PendSummonLimitTarget(e,c,sump,sumtype,sumpos,targetp)
-- 	local c = nil
-- 	if e then c = e:GetHandler() end
-- 	return c and sumtype==SUMMON_TYPE_PENDULUM and _G["c" .. c:GetOriginalCode()].pend_filter==nil 
-- 	and (c == Duel.GetFieldCard(tp,LOCATION_SZONE, 6) or c == Duel.GetFieldCard(tp,LOCATION_SZONE, 7))
-- end

function Nef.EnableDualAttributeSP(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e1)
end

function Nef.EnableDualAttribute(c, flag)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(aux.DualNormalCondition)
	e2:SetValue(TYPE_NORMAL+TYPE_DUAL+TYPE_MONSTER+flag)
	c:RegisterEffect(e2)
end

function Nef.IsDate(Year, Month, Day)
	local year = Year or -1
	local month = Month or -1
	local day = Day or -1
	local date = os.date("*t")
	return (date.year==year or year<0) and (date.month==month or month<0) and (date.day==day or day<0)
end

function Nef.GetDate()
	local date = os.date("*t")
	return date.year, date.month, date.day
end

function Nef.Log(message)
	-- if AI and AI.Chat ~= nil then AI.Chat(message) end
end

function Nef.LogFormat(fmt, ...)
	Debug.Message(string.format(fmt, ...))
end

function Nef.GetRandomCardCode(num, command)
	-- local result = {}
	-- local commandList = {
	-- 	[0] = "Main",
	-- 	[1] = "Extra"
	-- }
	-- local cardType = commandList[command]
	-- for i=1,num do
	-- 	local r = math.random(1,#CardList[cardType])
	-- 	result[i] = CardList[cardType][r]
	-- end
	-- return result
end

function Nef.kangbazi(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
		local ec=te:GetOwner()
		if ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<=10 and ec:GetOriginalRank()>=4
		else
			return ec:GetOriginalLevel()<=10 and ec:GetOriginalLevel()>=4
		end
	else
		return false
	end
end

Nef.order_table=Nef.order_table or {}
Nef.order_count=Nef.order_count or 0
function Nef.order_table_new(v)
	Nef.order_count=Nef.order_count+1
	Nef.order_table[Nef.order_count]=v
	return Nef.order_count
end

function Nef.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and ct<=max and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(Nef.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function Nef.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<=max and f(sg,...) then return true end
	return g:IsExists(Nef.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function Nef.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	local cg=cg or Group.CreateGroup()
	sg:Merge(cg)
	local ct=sg:GetCount()
	local ag=g:Filter(Nef.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)	
	while ct<max and ag:GetCount()>0 do
		local finish=(ct>=min and ct<=max and f(sg,...))
		local seg=sg:Clone()
		local dmin=min-cg:GetCount()
		local dmax=math.min(max-cg:GetCount(),g:GetCount())
		seg:Sub(cg)
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tc=ag:SelectUnselect(seg,tp,finish,finish,dmin,dmax)
		if not tc then break end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
		ct=sg:GetCount()
		ag=g:Filter(Nef.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
	end
	return sg
end
function Nef.SelectGroupWithCancel(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	local cg=cg or Group.CreateGroup()
	sg:Merge(cg)
	local ct=sg:GetCount()
	local ag=g:Filter(Nef.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)	
	while ct<max and ag:GetCount()>0 do
		local finish=(ct>=min and ct<=max and f(sg,...))
		local cancel=finish or ct==0
		local seg=sg:Clone()
		local dmin=min-cg:GetCount()
		local dmax=math.min(max-cg:GetCount(),g:GetCount())
		seg:Sub(cg)
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tc=ag:SelectUnselect(seg,tp,finish,cancel,dmin,dmax)
		if not tc then
			if not finish then return end
			break
		end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
		else
			sg:AddCard(tc)
		end
		ct=sg:GetCount()
		ag=g:Filter(Nef.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
	end
	return sg
end

function Nef.OverlayCard(c,tc,xm,nchk)
	if not nchk and (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or not c:IsType(TYPE_XYZ) or tc:IsType(TYPE_TOKEN)) then return end
	if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
		tc:CancelToGrave()
	end
	if tc:GetOverlayCount()>0 then
		local og=tc:GetOverlayGroup()
		if xm then
			Duel.Overlay(c,og)
		else
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(c,tc)
end
function Nef.OverlayFilter(c,nchk)
	return nchk or not c:IsType(TYPE_TOKEN)
end
function Nef.OverlayGroup(c,g,xm,nchk)
	if not nchk and (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or g:GetCount()<=0 or not c:IsType(TYPE_XYZ)) then return end
	local tg=g:Filter(Nef.OverlayFilter,nil,nchk)
	if tg:GetCount()==0 then return end
	local og=Group.CreateGroup()
	for tc in aux.Next(tg) do
		if tc:IsStatus(STATUS_LEAVE_CONFIRMED) then
			tc:CancelToGrave()
		end
		og:Merge(tc:GetOverlayGroup())
	end
	if og:GetCount()>0 then
		if xm then
			Duel.Overlay(c,og)
		else
			Duel.SendtoGrave(og,REASON_RULE)
		end
	end
	Duel.Overlay(c,tg)
end
function Nef.CheckFieldFilter(g,tp,c,f,...)
	return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and (not f or f(g,...))
end
function Nef.AddXyzProcedureCustom(c,func,gf,minc,maxc,xm,...)
	local ext_params={...}
	if c.xyz_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.xyz_filter=func or aux.TRUE
		mt.xyz_count=minc
	end	
	local maxc=maxc or minc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Nef.XyzProcedureCustomCondition(func,gf,minc,maxc,ext_params))
	e1:SetTarget(Nef.XyzProcedureCustomTarget(func,gf,minc,maxc,ext_params))
	e1:SetOperation(Nef.XyzProcedureCustomOperation(xm))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	return e1
end
function Nef.XyzProcedureCustomTuneMagicianFilter(c,te)
	local f=te:GetValue()
	return f(te,c)
end
function Nef.XyzProcedureCustomTuneMagicianCheck(c,g)
	local eset={c:IsHasEffect(EFFECT_TUNE_MAGICIAN_X)}
	for _,te in ipairs(eset) do
		if g:IsExists(Nef.XyzProcedureCustomTuneMagicianFilter,1,c,te) then return true end
	end
	return false
end
function Nef.XyzProcedureCustomCheck(g,xyzc,tp,gf)
	if g:IsExists(Nef.XyzProcedureCustomTuneMagicianCheck,1,nil,g) then return false end
	return not gf or gf(g,xyzc,tp)
end
function Nef.XyzProcedureCustomFilter(c,xyzcard,func,ext_params)
	if c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:IsCanBeXyzMaterial(xyzcard) and (not func or func(c,xyzcard,table.unpack(ext_params)))
end
function Nef.XyzProcedureCustomCondition(func,gf,minct,maxct,ext_params)
	return function(e,c,og,min,max)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local minc=minct or 2
		local maxc=maxct or minct or 63
		if min then
			minc=math.max(minc,min)
			maxc=math.min(maxc,max)
		end
		local mg=nil
		if og then
			mg=og:Filter(Nef.XyzProcedureCustomFilter,nil,c,func,ext_params)
		else
			mg=Duel.GetMatchingGroup(Nef.XyzProcedureCustomFilter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
		end
		local sg=Group.CreateGroup()
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_XMATERIAL)}
		for _,te in ipairs(ce) do
			local tc=te:GetHandler()
			if not mg:IsContains(tc) then return false end
			sg:AddCard(tc)
		end
		return maxc>=minc and Nef.CheckGroup(mg,Nef.CheckFieldFilter,sg,minc,maxc,tp,c,Nef.XyzProcedureCustomCheck,c,tp,gf)
	end
end
function Nef.XyzProcedureCustomTarget(func,gf,minct,maxct,ext_params)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
		local g=nil
		if og and not min then
			g=og
		else
			local mg=nil
			if og then
				mg=og:Filter(Nef.XyzProcedureCustomFilter,nil,c,func,ext_params)
			else
				mg=Duel.GetMatchingGroup(Nef.XyzProcedureCustomFilter,tp,LOCATION_MZONE,0,nil,c,func,ext_params)
			end
			local minc=minct or 2
			local maxc=maxct or minct or 63
			if min then
				minc=math.max(minc,min)
				maxc=math.min(maxc,max)
			end
			local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_XMATERIAL)}
			for _,te in ipairs(ce) do
				local tc=te:GetHandler()
				sg:AddCard(tc)
			end
			g=Nef.SelectGroupWithCancel(tp,HINTMSG_XMATERIAL,mg,Nef.CheckFieldFilter,sg,minc,maxc,tp,c,Nef.XyzProcedureCustomCheck,c,tp,gf)
		end
		if g then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else return false end
	end
end
function Nef.XyzProcedureCustomOperation(xm)
	return function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		Nef.OverlayGroup(c,g,xm,true)
		g:DeleteGroup()
	end
end

function Nef.CommonCounterGroup(c, code)
	Nef.ccg = Nef.ccg or {}
	Nef.counter = Nef.counter or {[0] = {}, [1] = {},}
	if not Nef.ccg[code] then
		Nef.ccg[code] = Group.CreateGroup()
		Nef.ccg[code]:KeepAlive()
		Nef.counter[0][code] = 0
		Nef.counter[1][code] = 0
	end

	if not Nef.ccg[code]:IsContains(c) then
		Nef.ccg[code]:AddCard(c)
	end
end

function Nef.AddCommonCounter(num, code, tp)
	if not tp then
		Nef.AddCommonCounter(num, code, 0)
		Nef.AddCommonCounter(num, code, 1)
		return
	end
	if Nef.ccg[code] then
		Nef.counter[tp][code] = Nef.counter[tp][code] + num
		if Nef.counter[tp][code] < 0 then Nef.counter[tp][code] = 0 end
		local tag = math.min(Nef.counter[tp][code], 11)

		local tc = Nef.ccg[code]:GetFirst()
		while tc do
			if tc:IsControler(tp) then
				tc:ResetFlagEffect(999900+code)
				if tc:IsLocation(LOCATION_ONFIELD) and tag > 0 then
					tc:RegisterFlagEffect(999900+code, RESET_EVENT+0xfe0000, EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE, 0, 0, 
						aux.Stringid(code, tag))
				end
			end
			tc = Nef.ccg[code]:GetNext()
		end
	end
end

function Nef.SetCommonCounter(num, code, tp)
	if not tp then
		Nef.SetCommonCounter(num, code, 0)
		Nef.SetCommonCounter(num, code, 1)
		return
	end
	if Nef.ccg[code] then
		Nef.counter[tp][code] = num
		Nef.AddCommonCounter(0, code, tp)
	end
end

function Nef.GetCommonCounter(code, tp)
	local result = 0
	if Nef.counter[tp] then
		result = Nef.counter[tp][code] or 0
	end
	return result
end

function Nef.RefreshCommonCounter(c, code)
	local tag = math.min(Nef.counter[c:GetControler()][code], 11)
	c:ResetFlagEffect(999900+code)
	if tag > 0 then
		c:RegisterFlagEffect(999900+code, RESET_EVENT+0xfe0000, EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE, 0, 0, 
			aux.Stringid(code, tag))
	end
end
function Nef.AddSummonMusic(c,desc,stype)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	if stype then
		e1:SetCondition(Nef.SummonTypeCondition(stype))
	end
	e1:SetOperation(function()
		Duel.Hint(11,0,desc)
	end)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function Nef.AddLinkProcedureWithDesc(c,f,min,max,gf,desc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetDescription(desc)
	if max==nil then max=99 end
	e1:SetCondition(Auxiliary.LinkCondition(f,min,max,gf))
	e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	return e1
end

function Nef.DeepCopy(tbl)
	local t = {}
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			t[k] = Nef.DeepCopy(v)
		else
			t[k] = v
		end
	end
	return t
end

function Nef.GetAllArrow(c)
	local res = {}
	local list = {
		LINK_MARKER_BOTTOM_LEFT,
		LINK_MARKER_BOTTOM,
		LINK_MARKER_BOTTOM_RIGHT,
		LINK_MARKER_LEFT,
		LINK_MARKER_RIGHT,
		LINK_MARKER_TOP_LEFT,
		LINK_MARKER_TOP,
		LINK_MARKER_TOP_RIGHT,
	}
	for i = 1, #list do
		if c:IsLinkMarker(list[i]) then
			res[#res+1] = list[i]
		end
	end
	return res
end

-- this group include cards in szone
function Nef.GetLinkArrowGroup(c)
	local g = Group.CreateGroup()
	if c:IsOnField() then 
		local tp = c:GetControler()
		local loc = c:GetLocation()
		local seq = c:GetSequence()

		if c:IsLinkMarker(LINK_MARKER_TOP) then
			local tc = Nef.getDir8CardByPos(tp, loc, seq)
			if tc then g:AddCard(tc) end
		end

		if c:IsLinkMarker(LINK_MARKER_TOP_LEFT) then
			local tc = Nef.getDir7CardByPos(tp, loc, seq)
			if tc then g:AddCard(tc) end
		end

		if c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) then
			local tc = Nef.getDir9CardByPos(tp, loc, seq)
			if tc then g:AddCard(tc) end
		end

		if c:IsLinkMarker(LINK_MARKER_LEFT) then
			local tc = Nef.getDir4CardByPos(tp, loc, seq)
			if tc then g:AddCard(tc) end
		end

		if c:IsLinkMarker(LINK_MARKER_RIGHT) then
			local tc = Nef.getDir6CardByPos(tp, loc, seq)
			if tc then g:AddCard(tc) end
		end

		if c:IsLinkMarker(LINK_MARKER_BOTTOM) then
			local tc = Nef.getDir2CardByPos(tp, loc, seq)
			if tc then g:AddCard(tc) end
		end

		if c:IsLinkMarker(LINK_MARKER_BOTTOM_LEFT) then
			local tc = Nef.getDir1CardByPos(tp, loc, seq)
			if tc then g:AddCard(tc) end
		end

		if c:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then
			local tc = Nef.getDir3CardByPos(tp, loc, seq)
			if tc then g:AddCard(tc) end
		end
	end
	return g
end

function Nef.getDir8CardByPos(tp, loc, seq)
	if loc == LOCATION_MZONE then
		if seq == 1 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 5)
		elseif seq == 3 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 6)
		elseif seq == 5 then
			return Duel.GetFieldCard(1-tp, LOCATION_MZONE, 3)
		elseif seq == 6 then
			return Duel.GetFieldCard(1-tp, LOCATION_MZONE, 1)
		end
	else
		return Duel.GetFieldCard(tp, LOCATION_MZONE, seq)
	end
end

function Nef.getDir7CardByPos(tp, loc, seq)
	if loc == LOCATION_MZONE then
		if seq == 2 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 5)
		elseif seq == 4 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 6)
		elseif seq == 5 then
			return Duel.GetFieldCard(1-tp, LOCATION_MZONE, 4)
		elseif seq == 6 then
			return Duel.GetFieldCard(1-tp, LOCATION_MZONE, 2)
		end
	else
		if seq > 0 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, seq-1)
		end
	end
end

function Nef.getDir9CardByPos(tp, loc, seq)
	if loc == LOCATION_MZONE then
		if seq == 0 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 5)
		elseif seq == 2 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 6)
		elseif seq == 5 then
			return Duel.GetFieldCard(1-tp, LOCATION_MZONE, 2)
		elseif seq == 6 then
			return Duel.GetFieldCard(1-tp, LOCATION_MZONE, 4)
		end
	else
		if seq < 4 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, seq+1)
		end
	end
end

function Nef.getDir4CardByPos(tp, loc, seq)
	if loc == LOCATION_MZONE then
		if 1 < seq and seq < 5 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, seq-1)
		end
	else
		if 1 < seq and seq < 5 then
			return Duel.GetFieldCard(tp, LOCATION_SZONE, seq-1)
		end
	end
end

function Nef.getDir6CardByPos(tp, loc, seq)
	if loc == LOCATION_MZONE then
		if 0 < seq and seq < 4 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, seq+1)
		end
	else
		if 0 < seq and seq < 4 then
			return Duel.GetFieldCard(tp, LOCATION_SZONE, seq+1)
		end
	end
end

function Nef.getDir2CardByPos(tp, loc, seq)
	if loc == LOCATION_MZONE then
		if seq == 5 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 1)
		elseif seq == 6 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 3)
		else
			return Duel.GetFieldCard(tp, LOCATION_SZONE, seq)
		end
	end
end

function Nef.getDir1CardByPos(tp, loc, seq)
	if loc == LOCATION_MZONE then
		if seq == 5 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 0)
		elseif seq == 6 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 2)
		elseif seq > 0 then
			return Duel.GetFieldCard(tp, LOCATION_SZONE, seq-1)
		end
	end
end

function Nef.getDir3CardByPos(tp, loc, seq)
	if loc == LOCATION_MZONE then
		if seq == 5 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 2)
		elseif seq == 6 then
			return Duel.GetFieldCard(tp, LOCATION_MZONE, 4)
		elseif seq < 4 then
			return Duel.GetFieldCard(tp, LOCATION_SZONE, seq+1)
		end
	end
end
function Nef.RegisterBigFiendEffect(c,e)
	c:RegisterEffect(e)
	local ex=e:Clone()
	ex:SetRange(LOCATION_HAND)
	local con=e:GetCondition()
	ex:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return (not con or con(e,tp,eg,ep,ev,re,r,rp)) and Duel.IsPlayerAffectedByEffect(tp,22211) and e:GetHandler():IsSetCard(0x222)
	end)
	if ex:IsHasType(EFFECT_TYPE_IGNITION) then
		ex:SetType((ex:GetType() & ~EFFECT_TYPE_IGNITION) | EFFECT_TYPE_QUICK_O)
		ex:SetCode(EVENT_FREE_CHAIN)
		ex:SetHintTiming(0,0x1c0)
	end
	c:RegisterEffect(ex)	
end
