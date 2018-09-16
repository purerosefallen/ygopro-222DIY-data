--死亡骑士·里德
function c69696908.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),3,2)
	c:EnableReviveLimit()
	--Overlay
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(c69696908.reptg)
	e1:SetValue(c69696908.repval)
	c:RegisterEffect(e1)
	local dg=Group.CreateGroup()
	dg:KeepAlive()
	e1:SetLabelObject(dg)
	--atklimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c69696908.atkval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(69696908,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c69696908.spcost)
	e3:SetTarget(c69696908.sptg)
	e3:SetOperation(c69696908.spop)
	c:RegisterEffect(e3)
end
function c69696908.repfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_DESTROY) and not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler() and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c69696908.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c69696908.repfilter,e:GetHandler())
		return count>0
	end
	if Duel.SelectYesNo(tp,aux.Stringid(69696908,0)) then
		local g=eg:Filter(c69696908.repfilter,e:GetHandler())
		local container=e:GetLabelObject()
		container:Clear()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(69696908,2))
		local dg=g:Select(tp,1,g:GetCount(),nil)
		Duel.HintSelection(dg)
		if dg:GetCount()>0 then
			local tc=dg:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				Duel.Overlay(e:GetHandler(),Group.FromCards(tc))
				tc=dg:GetNext()
			end
			container:Merge(dg)
		end
		return true
	end
	return false
end
function c69696908.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end
function c69696908.atkval(e,c)
	return Duel.GetOverlayCount(c:GetControler(),1,0)*200
end
function c69696908.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c69696908.spfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c69696908.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c69696908.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c69696908.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c69696908.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c69696908.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRace(RACE_ZOMBIE) and tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end