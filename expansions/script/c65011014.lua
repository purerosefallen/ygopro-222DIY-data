--时终焉 阿卡纳
function c65011014.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c65011014.lcheck)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,65011024)
	e1:SetCondition(c65011014.thcon)
	e1:SetTarget(c65011014.thtg)
	e1:SetOperation(c65011014.thop)
	c:RegisterEffect(e1)
	--cos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65011024,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,65011014)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c65011014.costg)
	e2:SetOperation(c65011014.cosoperation)
	c:RegisterEffect(e2)
end
function c65011014.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==1 and g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c65011014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65011014.thfilter(c)
	return (c:IsSetCard(0xda2) or (c:IsSetCard(0x46) and c:IsType(TYPE_SPELL))) and c:IsAbleToHand()
end
function c65011014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011014.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c65011014.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65011014.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c65011014.filter2(c,fc)
	if not c:IsAbleToGraveAsCost() then return false end
	return c:IsCode(table.unpack(fc.material))
end
function c65011014.filter1(c,tp)
	return c.material and Duel.IsExistingMatchingCard(c65011014.filter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c65011014.costg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011014.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
end
function c65011014.cosoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c65011014.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c65011014.filter2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
	Duel.SendtoGrave(cg,REASON_EFFECT)
	local code=cg:GetFirst():GetCode()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(code)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65011014,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetLabelObject(e1)
	e2:SetOperation(c65011014.rstop)
	c:RegisterEffect(e2)
end
function c65011014.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end