local m=12012000
local cm=_G["c"..m]
--地天使 
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(TYPE_TUNER)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.tgtg)
	c:RegisterEffect(e1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11548522,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetTarget(cm.bantg)
	e1:SetOperation(cm.banop)
	c:RegisterEffect(e1)
end
function cm.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function cm.banop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end
function cm.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function cm.matfilter(c)
	return ( c:IsLinkRace(RACE_FAIRY) or c:IsLinkRace(RACE_WARRIOR) or c:IsLinkRace(RACE_SPELLCASTER) ) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function cm.cfilter(c,g,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and ( c:IsLinkRace(RACE_BEASTWARRIOR) or c:IsLinkRace(RACE_BEAST) ) and g:IsContains(c)
end
function cm.filter2(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler():GetLinkedGroup(),tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local tc=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not Duel.Destroy(tc,REASON_EFFECT)==0 then
	   local code=tc:GetCode()
	   local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			 e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			 e1:SetCode(EFFECT_CHANGE_CODE)
			 e1:SetValue(code)
			 e:GetHandler():RegisterEffect(e1)
	Duel.BreakEffect()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode(),e,tp)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
