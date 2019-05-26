--幻量子呼唤者
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=18007001
local cm=_G["c"..m]
if not rsv.PhantomQuantum then
	rsv.PhantomQuantum={}
	rspq=rsv.PhantomQuantum
function rspq.ToDeckFun(c,code)
	local e1=rsef.STO(c,EVENT_TO_DECK,{m,0},{1,code},"sp","de",rspq.tdcon,nil,rstg.target(rsop.list(rspq.spfilter(code),"sp",LOCATION_DECK)),rspq.tdop(code))
	return e1
end
function rspq.tdcon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function rspq.spfilter(code)
	return function(c,e,tp)
		return not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:CheckSetCard("PhantomQuantum")
	end
end
function rspq.tdop(code)
	return function(e,tp)
		rsof.SelectHint(tp,"sp")
		local sg=Duel.SelectMatchingCard(tp,rspq.spfilter(code),tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #sg>0 then
			rssf.SpecialSummon(sg)
		end
	end
end
function rspq.SpecialSummonFun(c,code,cate,tg,op)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{code,1},{1,code+100},cate,"de",rspq.sscon,nil,tg,op)
end
function rspq.sscon(e,tp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function rspq.LeaveFieldFun(c,code,isnoeffect,isnoposlimit)
	local e1=rsef.STO(c,EVENT_LEAVE_FIELD,{m,0},nil,"sp","de",rspq.lfcon(isnoeffect),nil,rstg.target(rsop.list(rspq.lfspfilter(isnoposlimit),"sp",LOCATION_DECK)),rspq.lfop(isnoposlimit))
end
function rspq.lfcon(isnoeffect)
	return function(e,tp)
		local c=e:GetHandler()
		return c:IsPreviousPosition(POS_FACEUP) and (not isnoeffect or c:IsReason(REASON_EFFECT))
	end
end
function rspq.lfspfilter(isnoposlimit)
	return function(c,e,tp)
		local pos=isnoposlimit and POS_FACEUP or POS_FACEUP_DEFENSE 
		return c:CheckSetCard("PhantomQuantum") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,pos) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end
function rspq.lfop(isnoposlimit)
	return function(e,tp)
		local pos=isnoposlimit and POS_FACEUP or POS_FACEUP_DEFENSE 
		rsof.SelectHint(tp,"sp")
		local sg=Duel.SelectMatchingCard(tp,rspq.lfspfilter(isnoposlimit),tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,pos)
		end
	end
end
function rspq.FusionSummonFun(c,code,iscanfusion,filter1,reqlv,minct)
	local f1,f2,maxct=nil
	if not minct then minct=1 end
	local sumval=iscanfusion and rspq.splimit2 or rspq.splimit1
	local e1=rscf.SetSummonCondition(c,false,sumval)
	if filter1 then
		f1=function(mc,tp)
			return mc:IsFusionCode(18007005) and mc:IsControler(tp)
		end
		f2=function(mc,tp)
			return mc:IsLocation(LOCATION_MZONE) and mc:IsLevelBelow(reqlv) and mc:IsControler(tp)
		end
		aux.AddFusionProcCodeFunRep(c,18007005,rspq.ffilter,1,99,true,true)
	else
		f1=function(mc)
			return mc:CheckFusionSetCard("PhantomQuantum") and mc:IsLocation(LOCATION_MZONE)
		end
		f2=function(mc)
			return mc:IsLocation(LOCATION_MZONE) and rspq.ffilter2(mc) 
		end
		maxct=1
		aux.AddFusionProcFun2(c,aux.FilterBoolFunction(rscf.CheckFusionSetCard,"PhantomQuantum"),rspq.ffilter2,true)
	end
	local e2=rscf.SetSpecialSummonProduce(c,LOCATION_EXTRA,rspq.sprcon(f1,f2,maxct,reqlv,minct),rspq.sprop(f1,f2,maxct,reqlv,minct))
	return e1,e2
end
function rspq.sprcon(f1,f2,maxct,reqlv,minct)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local mg1=Duel.GetMatchingGroup(rspq.sprfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fc)
		return mg1:CheckSubGroup(rspq.spcheck,1,3,c,tp,f1,f2,maxct,reqlv,minct)
	end
end
function rspq.sprfilter(c,fc)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial(fc)
end
function rspq.spcheck(g,fc,tp,f1,f2,maxct,reqlv,minct)
	if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return false end
	if maxct and #g~=maxct+1 then return false end
	if minct and #g<minct+1 then return false end
	local f1g=g:Filter(f1,nil,tp)
	if #f1g<=0 then return false end
	for tc in aux.Next(f1g) do
		if reqlv then
			local sg=g:Clone()
			sg:RemoveCard(tc)
			if sg:FilterCount(f2,nil,tp)~=#sg then return false end
			if sg:GetSum(Card.GetLevel)==reqlv then return true end
		else
			if g:IsExists(f2,1,tc,tp) then return true end
		end 
	end
	return false
end
function rspq.sprop(f1,f2,maxct,reqlv,minct)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local mg1=Duel.GetMatchingGroup(rspq.sprfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fc)
		local mat=mg1:SelectSubGroup(tp,rspq.spcheck,false,1,3,c,tp,f1,f2,maxct,reqlv,minct)
		local setg=mat:Filter(Card.IsFacedown,nil)
		if #setg>0 then
			Duel.ConfirmCards(1-tp,setg)
		end
		Duel.SendtoDeck(mat,nil,2,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	end
end
function rspq.splimit1(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) 
end
function rspq.splimit2(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function rspq.ffilter(c,fc,sub,mg,sg)
	local tg=sg:Filter(Card.IsCode,nil,18007005)
	if c:IsLevelAbove(6) then return false end
	if not sg then return true end
	for tc in aux.Next(tg) do
		local sg2=sg:Clone()
		sg2:RemoveCard(tc)
		if sg2:GetSum(Card.GetLevel)==5 then return true end
	end
	return false
end
function rspq.ffilter2(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:GetSummonLocation()==LOCATION_DECK 
end
------------
end
------------
if cm then
function cm.initial_effect(c)
	local e1=rspq.ToDeckFun(c,m)
	local e2=rspq.SpecialSummonFun(c,m,nil,rstg.target(rsop.list(cm.setfilter,nil,LOCATION_DECK)),cm.setop)
end
cm.rssetcode="PhantomQuantum"
function cm.setfilter(c)
	return c:CheckSetCard("PhantomQuantum") and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.setop(e,tp)
	rsof.SelectHint(tp,HINTMSG_SET)
	local sg=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #sg>0 then
		Duel.SSet(tp,sg:GetFirst())
		Duel.ConfirmCards(1-tp,sg)
	end
end
------------
end
