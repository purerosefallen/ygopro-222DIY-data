--破晓之花 プルシュカ
function c33330013.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x556),2,2)
	c:EnableReviveLimit()
	--seq
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330013,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c33330013.target)
	e1:SetOperation(c33330013.activate)
	c:RegisterEffect(e1)
	--d r
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33330013,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33330013)
	e2:SetTarget(c33330013.destg)
	e2:SetOperation(c33330013.desop)
	c:RegisterEffect(e2)  
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c33330013.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)   
end
function c33330013.atktg(e,c)
	return c:GetMutualLinkedGroupCount()>0 and c:IsSetCard(0x556)
end
function c33330013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
end
function c33330013.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
end
function c33330013.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and Duel.IsExistingMatchingCard(c33330013.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_FZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c33330013.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(33330034)
end
function c33330013.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c33330013.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c33330013.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	   Duel.SendtoHand(tg,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,tg)
	end
end



