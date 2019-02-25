--诺札利亚 奥尔黛西亚
local m=1171006
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_NozaLeah=true
--
function c1171006.initial_effect(c)
--
	aux.AddLinkProcedure(c,nil,3,4,c1171006.lcheck)
	c:EnableReviveLimit()
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)  
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1171006.imcon2)
	e2:SetValue(c1171006.efilter2)
	c:RegisterEffect(e2)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1171006,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1171006)
	e1:SetTarget(c1171006.tg1)
	e1:SetOperation(c1171006.op1)
	c:RegisterEffect(e1)
--
end
--
function c1171006.checkfilter(c)
	return muxu.check_link_set_NozaLeah(c)
end
function c1171006.lcheck(g,lc)
	return g:IsExists(c1171006.checkfilter,1,nil)
end
--
function c1171006.imcon2(e)
	return e:GetHandler():GetFirstCardTarget()
end
function c1171006.efilter2(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--
function c1171006.tfilter1(c,e,tp,zone)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c1171006.xyzfilter1(c,mg,ct)
	return c:IsXyzSummonable(mg,1,ct)
end
function c1171006.xycfilter1(c,ng,num)
	return c:IsXyzSummonable(ng,num,num)
end
function c1171006.chkfilter1(c,mg,exg,ng,ct,tp)
	ng:AddCard(c)
	local res=false
	if ng:GetCount()>=ct or ng:GetCount()>=mg:GetCount() 
		or (ng:GetCount()==1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then
		res=exg:IsExists(c1171006.xycfilter1,1,nil,ng,ng:GetCount())
	else
		res=exg:IsExists(c1171006.xycfilter1,1,nil,ng,ng:GetCount()) or mg:IsExists(c1171006.chkfilter1,1,ng,mg,exg,ng,ct,tp)
	end
	ng:RemoveCard(c)
	return res
end
function c1171006.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	local cg=c:GetLinkedGroup()
	local zone=c:GetLinkedZone(tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local mg=Duel.GetMatchingGroup(c1171006.tfilter1,tp,LOCATION_GRAVE,0,nil,e,tp,zone)
	local exg=Duel.GetMatchingGroup(c1171006.xyzfilter1,tp,LOCATION_EXTRA,0,nil,mg,ct)
	local ng=Group.CreateGroup()
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetMZoneCount(tp)>0
		and Duel.GetLocationCountFromEx(tp)>0
		and mg:IsExists(c1171006.chkfilter1,1,nil,mg,exg,ng,ct,tp)
	end
	local mat=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=mg:FilterSelect(tp,c1171006.chkfilter1,1,1,mat,mg,exg,mat,ct,tp)
		mat:Merge(sg)
	until mat:GetCount()>=ct
		or mat:GetCount()>=mg:GetCount()
		or (ng:GetCount()==1 and Duel.IsPlayerAffectedByEffect(tp,59822133))
		or (not mg:IsExists(c1171006.chkfilter1,1,mat,mg,exg,mat,ct,tp))
		or ((exg:IsExists(c1171006.xycfilter1,1,nil,mat,mat:GetCount()))
			and not Duel.SelectYesNo(tp,aux.Stringid(1171006,1)))
	Duel.SetTargetCard(mat)
	local cnt=mat:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mat,cnt,0,0)
end
--
function c1171006.mofilter1(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1171006.xyofilter1(c,sg)
	return c:IsXyzSummonable(mg,sg:GetCount(),sg:GetCount())
end
function c1171006.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(c1171006.mofilter1,nil,e,tp)
	if sg:GetCount()<=0 then return end
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local zone=c:GetLinkedZone(tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	if ct<sg:GetCount() then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)
	if Duel.GetLocationCountFromEx(tp,tp,sg)<=0 then return end
	local xyzg=Duel.GetMatchingGroup(c1171006.xyofilter1,tp,LOCATION_EXTRA,0,nil,sg)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.BreakEffect()
		Duel.XyzSummon(tp,xyz,g)
		xyz:SetCardTarget(tc)
	end
end
--