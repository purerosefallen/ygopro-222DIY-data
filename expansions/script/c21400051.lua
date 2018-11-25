--露文律的雕斧
local m=21400051
local cm=_G["c"..m]
function c21400051.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21400051,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_REMOVE+CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c21400051.cost)
	e1:SetTarget(c21400051.target)
	e1:SetOperation(c21400051.operation)
	c:RegisterEffect(e1)

	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21400051,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,21400051)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c21400051.sstarget)
	e2:SetOperation(c21400051.ssactivate)
	c:RegisterEffect(e2)

end

function c21400051.kfilter(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsPosition(POS_FACEUP)  and c:IsType(TYPE_PENDULUM) ) ) and c:IsAbleToGraveAsCost() and (c:IsRace(RACE_PLANT) or c:IsRace(RACE_WYRM))
end

function c21400051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21400051.kfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21400051.kfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c21400051.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end

function c21400051.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end

function c21400051.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end

function c21400051.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local flg=0
	if tc:IsRelateToEffect(e) then
		if (Duel.IsExistingMatchingCard(c21400051.cfilter,tp,LOCATION_MZONE,0,1,nil) and tc:IsPosition(POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(21400051,2)) ) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then flg=1 end
		else 
			if Duel.Destroy(tc,REASON_EFFECT)>0 then flg=1 end
		end
	end
	if (flg==1 and Duel.IsExistingMatchingCard(c21400051.thfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) and Duel.SelectYesNo(tp,aux.Stringid(21400051,3))) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c21400051.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end






function cm.spfilter(c,e,tp,mc,rg0)
	return bit.band(c:GetOriginalType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc) or (rg0 and rg0:IsContains(c)))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and (mc:IsCanBeRitualMaterial(c) or (rg0 and rg0:IsContains(c))) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,mc)>0) or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,mc,tp)>0)) and cm.lvfilter(c)>0 and c:IsSetCard(0xc21)
end
function cm.lvfilter(c)
	local lv=c:GetLevel()
	if not c:IsLocation(LOCATION_HAND) then
	   lv=c:GetOriginalLevel()
	end
	return lv
end
function cm.rfilter(c,mc,notbool)
	local lv=cm.lvfilter(c)
	local mlv=mc:GetRitualLevel(c)
	local lv=c:GetLevel()
	return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16) or (mc:IsLevelAbove(lv) and notbool==false)
end
function cm.filter(c,e,tp)
	local sg1=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,c,e,tp,c)
	return sg1:IsExists(cm.rfilter,1,nil,c,false)
end
function cm.sstarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then return mg:IsExists(cm.filter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA)
end
function cm.rfilter2(c,sg,mlv)
	local lv1=sg:GetSum(cm.lvfilter)
	local lv2=cm.lvfilter(c)
	return lv1+lv2<=mlv
end
function cm.ssactivate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,cm.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Group.CreateGroup()
	local rg0=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,mc,e,tp,mc)
	local tf=false 
	repeat
		local rg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_PZONE+LOCATION_EXTRA,0,mc,e,tp,mc,rg0)
		if rg:GetCount()<=0 then break end
		local tc=nil
		if sg:GetCount()<=0 then
		   Duel.ReleaseRitualMaterial(mat)
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   tc=rg:Select(tp,1,1,nil):GetFirst()
		   if cm.rfilter(tc,mc,true) and (not cm.rfilter2(tc,sg,mc:GetLevel()) or Duel.SelectYesNo(tp,aux.Stringid(m,4))) then tf=true end
		else
		   if Duel.IsPlayerAffectedByEffect(tp,59822133) then break end
		   local sg2=rg:Filter(cm.rfilter2,nil,sg,mc:GetLevel()) 
		   if sg2:GetCount()<=0 then break end
		   if sg:GetCount()>0 and not Duel.SelectYesNo(tp,aux.Stringid(m,5)) then break end
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		   tc=sg2:Select(tp,1,1,nil):GetFirst()
		end
		if sg:GetCount()==1 then
		   Duel.BreakEffect()
		end
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		sg:AddCard(tc)
	until tf
	if sg:GetCount()>0 then
	   for tc in aux.Next(sg) do
		   tc:SetMaterial(mat)
		   tc:CompleteProcedure()
	   end
	   Duel.SpecialSummonComplete()
	end
end


















