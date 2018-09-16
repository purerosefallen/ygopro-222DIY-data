--雷电牙医 阿尔阿萨德
function c65010085.initial_effect(c)
	 --synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65010085.condition)
	e1:SetTarget(c65010085.target)
	e1:SetOperation(c65010085.operation)
	c:RegisterEffect(e1)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCountLimit(1,65010085)
	e5:SetCondition(c65010085.thcon)
	e5:SetTarget(c65010085.thtg)
	e5:SetOperation(c65010085.thop)
	c:RegisterEffect(e5)
end
function c65010085.cfilter(c,tp)
	return c:GetSummonPlayer()~=tp
end
function c65010085.condition(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c65010085.cfilter,1,nil,tp)
end
function c65010085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c65010085.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	if tg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
	local g=tg:RandomSelect(1-tp,1)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c65010085.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsPreviousPosition(POS_FACEUP)
end
function c65010085.thfilter(c,mg)
	return c:IsType(TYPE_TUNER) and mg:IsContains(c) and c:IsAbleToHand()
end
function c65010085.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=e:GetHandler():GetMaterial()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c65010085.thfilter(chkc,mg) end
	if chk==0 then return Duel.IsExistingTarget(c65010085.thfilter,tp,LOCATION_GRAVE,0,1,nil,mg) end
	local g=Duel.SelectTarget(tp,c65010085.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,mg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65010085.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end