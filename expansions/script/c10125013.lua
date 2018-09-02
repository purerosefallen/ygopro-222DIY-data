--钢牙-X
function c10125013.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c10125013.matfilter,1,1)
	c:EnableReviveLimit()
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9334))
	c:RegisterEffect(e1)  
	--duel status
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c10125013.tg)
	e2:SetCode(EFFECT_DUAL_STATUS)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10125013,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10125013)
	e3:SetCondition(c10125013.thcon)
	e3:SetTarget(c10125013.thtg)
	e3:SetOperation(c10125013.thop)
	c:RegisterEffect(e3)
end
function c10125013.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0x9334) and c:IsSetCard(0x9334) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c10125013.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10125013.cfilter,1,nil,tp)
end
function c10125013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10125013.thfilter(c)
	return c:IsSetCard(0x9334) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c10125013.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10125013.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end
function c10125013.matfilter(c)
	return c:IsLinkRace(RACE_MACHINE) and not c:IsLinkCode(10125013)
end
function c10125013.tg(e,c)
	return c:IsType(TYPE_DUAL) and e:GetHandler():GetLinkedGroup():IsContains(c)
end

