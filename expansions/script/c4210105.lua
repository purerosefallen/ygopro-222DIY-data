--天赐祝福的莉昂
function c4210105.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2,function(c)return c:IsFaceup()and c:IsSetCard(0x2ac)and c:IsType(TYPE_MONSTER) and not c:IsCode(4210105) end,aux.Stringid(4210105,0),2,function(e,tp,chk)if chk==0 then return Duel.GetFlagEffect(tp,4210105)==0 end	Duel.RegisterFlagEffect(tp,4210105,RESET_PHASE+PHASE_END,0,1)end)
	c:EnableReviveLimit()	
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4210105,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c4210105.cost)
	e1:SetOperation(c4210105.operation)
	c:RegisterEffect(e1)
	--get effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210105,2))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,4210105)
	e2:SetCondition(function(e)return e:GetHandler():IsType(TYPE_XYZ)end)
	e2:SetCost(c4210105.cost)
	e2:SetTarget(c4210105.mattg)
	e2:SetOperation(c4210105.matop)
	c:RegisterEffect(e2)
end
function c4210105.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function c4210105.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(function(e,c)return c:IsSetCard(0x2ac)end)
	e1:SetValue(300)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c4210105.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(function(c)return c:IsSetCard(0x2ac) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
end
function c4210105.matop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,function(c)return c:IsSetCard(0x2ac) and c:IsType(TYPE_MONSTER) end,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end