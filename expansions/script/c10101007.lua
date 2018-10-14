--苍翼佣兵团 马尔斯
function c10101007.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10101007,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10101007)
	e1:SetCost(c10101007.descost)
	e1:SetTarget(c10101007.destg)
	e1:SetOperation(c10101007.desop)
	c:RegisterEffect(e1)  
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10101007,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10101107)
	e2:SetTarget(c10101007.rmtg)
	e2:SetOperation(c10101007.rmop)
	c:RegisterEffect(e2)	
	local e3=e2:Clone()
	e3:SetCode(EVENT_RETURN_TO_GRAVE) 
	c:RegisterEffect(e3)   
end
function c10101007.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c10101007.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end
function c10101007.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 and og:FilterCount(c10101007.cfilter,nil)>0 end
	   if og:GetCount()>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10101007,1))
		  local tc=og:FilterSelect(tp,c10101007.cfilter,1,1,nil):GetFirst()
		  if tc then
			 Duel.BreakEffect()
			 local op1,op2=false,false
			 if tc:IsAbleToRemove() then op2=true end
			 if tc:IsAbleToGrave() then op1=true end
			 if op1 and op2 then
				if Duel.SelectYesNo(tp,aux.Stringid(10101007,2)) then
					Duel.Remove(tc,POS_FACEUP,REASON_COST)
				else
					Duel.SendtoGrave(tc,REASON_COST)
				end
			 elseif op1 then
					Duel.SendtoGrave(tc,REASON_COST)
			 else
					Duel.Remove(tc,POS_FACEUP,REASON_COST)
			 end
		  end
	   end
end
function c10101007.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c10101007.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
	   Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c10101007.cfilter(c)
	return c:IsAbleToRemove() or c:IsAbleToGrave()
end