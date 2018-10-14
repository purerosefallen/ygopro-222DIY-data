--苍翼佣兵团 芝琪
function c10101009.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x6330),4,2)
	c:EnableReviveLimit()   
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10101009,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10101009)
	e1:SetCost(c10101009.drcost)
	e1:SetTarget(c10101009.drtg)
	e1:SetOperation(c10101009.drop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c10101009.spreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10101009,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1,10101109)
	e3:SetCondition(c10101009.spcon)
	e3:SetTarget(c10101009.sptg)
	e3:SetOperation(c10101009.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3) 
end
function c10101009.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and c:GetFlagEffect(10101009)>0
end
function c10101009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:ResetFlagEffect(10101009)
end
function c10101009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10101009,4))
	local tc=Duel.SelectMatchingCard(tp,c10101009.xyzfilter,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if tc then
	   Duel.BreakEffect()
	   local og=tc:GetOverlayGroup()
	   if og:GetCount()>0 then
		  Duel.SendtoGrave(og,REASON_RULE)
	   end
	   Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c10101009.xyzfilter(c,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c10101009.spreg(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(Duel.GetTurnCount())
	e:GetHandler():RegisterFlagEffect(10101009,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
end
function c10101009.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c10101009.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 and og:FilterCount(c10101009.cfilter,nil)>0 end
	   if og:GetCount()>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10101009,2))
		  local tc=og:FilterSelect(tp,c10101009.cfilter,1,1,nil):GetFirst()
		  if tc then
			 Duel.BreakEffect()
			 local op1,op2=false,false
			 if tc:IsAbleToRemove() then op2=true end
			 if tc:IsAbleToGrave() then op1=true end
			 if op1 and op2 then
				if Duel.SelectYesNo(tp,aux.Stringid(10101009,3)) then
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
function c10101009.cfilter(c)
	return c:IsAbleToRemove() or c:IsAbleToGrave()
end
function c10101009.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
	   Duel.ShuffleHand(tp)
	   Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)
	end
end