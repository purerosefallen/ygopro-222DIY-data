--仪式聚合体
function c87000020.initial_effect(c)
	--synchro summon
 aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaff),aux.NonTuner(Card.IsSetCard,0xaff),1)
	c:EnableReviveLimit()

--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87000020,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,87000020)
	e2:SetTarget(c87000020.trtg)
	e2:SetOperation(c87000020.trop)
	c:RegisterEffect(e2)
--level
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87000020,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,87000020)
	e3:SetCost(c87000020.lvcost)
	e3:SetTarget(c87000020.lvtg)
	e3:SetOperation(c87000020.lvop)
	c:RegisterEffect(e3)
end



function c87000020.filter(c)
	return c:IsSetCard(0xaff) and c:IsAbleToHand()
end
function c87000020.trtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87000020.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c87000020.trop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c87000020.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c87000020.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c87000020.filter1(c)
	local lv=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0xaff) and lv>0 and lv~=7
end
function c87000020.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c87000020.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c87000020.lvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c87000020.filter1,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(7)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end














