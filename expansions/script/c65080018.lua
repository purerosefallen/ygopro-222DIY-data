--虚空海猎 丹克列尔
function c65080018.initial_effect(c)
	aux.AddXyzProcedure(c,aux.TRUE,3,2,nil,nil,99)
	c:EnableReviveLimit()
	--BACK
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65080018.cost)
	e1:SetTarget(c65080018.target)
	e1:SetOperation(c65080018.operation)
	c:RegisterEffect(e1)
end

function c65080018.bkfil(c)
	return c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_WIND) 
end

function c65080018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c65080018.bkfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end

function c65080018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65080018.bkfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c65080018.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c65080018.bkfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,c65080018.bkfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end