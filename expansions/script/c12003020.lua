local m=12003020
local cm=_G["c"..m]
--水歌 回奏龙麻由里
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckReleaseGroupEx(tp,cm.cfilter1,1,nil,tp) end
		local g1=Duel.SelectReleaseGroupEx(tp,cm.cfilter1,1,1,nil,tp)
		Duel.Release(g1,REASON_COST)
	end)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic()end
end
function cm.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),c)
	else return false end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ft=Duel.GetMZoneCount(tp)
		local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsReleasable,c)
		if c.mat_filter then
			mg=mg:Filter(c.mat_filter,nil)
		end
		if not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) then return end
		if ft>0 then
			return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
		else
			return mg:IsExists(cm.mfilterf,1,nil,tp,mg,c)
		end
	end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsReleasable,c)
	if c.mat_filter then
		mg=mg1:Filter(c.mat_filter,nil)
	end
	local mg=mg1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if mg:GetCount()==0 then return end
	local mat=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetLevel(),c)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		mat=mg:FilterSelect(tp,cm.mfilterf,1,1,nil,tp,mg,c)
		Duel.SetSelectedCard(mat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetLevel(),c)
		mat:Merge(mat2)
	end
	c:SetMaterial(mat)
	if mat:GetCount()==0 then return end
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	if Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0 then
		local tdg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE,0,nil)
		if tdg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local stdg=tdg:Select(tp,1,1,nil)
			Duel.HintSelection(stdg)
			Duel.SendtoDeck(stdg,nil,2,REASON_EFFECT)
		end
	end
	c:CompleteProcedure()
end
function cm.cfilter1(c,tp)
	return c:IsRace(RACE_SEASERPENT) and c:IsAbleToGraveAsCost()
end
function cm.tdfilter(c)
	return c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end