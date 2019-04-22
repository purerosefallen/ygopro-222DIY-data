--战场女武神 柯赛特
function c11113027.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11113027,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,11113027)
	e2:SetCondition(c11113027.condition)
	e2:SetTarget(c11113027.target)
	e2:SetOperation(c11113027.operation)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113027,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,11113027)
	e3:SetCondition(c11113027.spcon)
	e3:SetTarget(c11113027.sptg)
	e3:SetOperation(c11113027.spop)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetValue(LOCATION_REMOVED)
	e4:SetCondition(c11113027.rmcon)
	c:RegisterEffect(e4)
end
function c11113027.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c11113027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11113027.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11113027.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0x15c)
end
function c11113027.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	    and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local t={}
	local i=1
	for i=1,4 do t[i]=i end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11113027.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	        local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_SINGLE)
		    e1:SetCode(EFFECT_CHANGE_LEVEL)
		    e1:SetValue(e:GetLabel())
		    e1:SetReset(RESET_EVENT+0x1ff0000)
		    c:RegisterEffect(e1)
		    local e2=Effect.CreateEffect(c)
		    e2:SetType(EFFECT_TYPE_SINGLE)
		    e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		    e2:SetReset(RESET_EVENT+0x47e0000)
		    e2:SetValue(LOCATION_DECKBOT)
		    c:RegisterEffect(e2)
	    end
	end	
end
function c11113027.rmcon(e)
	local c=e:GetHandler()
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_SYNCHRO)
end