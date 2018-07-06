--朱槿花花园
function c1150027.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
-- 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c1150027.op2)
	c:RegisterEffect(e2)
	local e2_3=Effect.CreateEffect(c)
	e2_3:SetCategory(CATEGORY_RECOVER)
	e2_3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2_3:SetCode(EVENT_CHAIN_SOLVED)
	e2_3:SetRange(LOCATION_FZONE)
	e2_3:SetCondition(c1150027.con2_3)
	e2_3:SetOperation(c1150027.op2_3)
	Duel.RegisterEffect(e2_3,tp)
-- 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1150027,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,1150027)
	e3:SetCost(c1150027.cost3)
	e3:SetCondition(c1150027.con3)
	e3:SetTarget(c1150027.tg3)
	e3:SetOperation(c1150027.op3)
	c:RegisterEffect(e3)
--
	if not c1150027.gchk then
		c1150027.gchk=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e0:SetCode(EVENT_RECOVER)
		e0:SetOperation(c1150027.op0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1150027,1))
	e4:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,1150029)
	e4:SetCondition(c1150027.con4)
	e4:SetTarget(c1150027.tg4)
	e4:SetOperation(c1150027.op4)
	c:RegisterEffect(e4)
--
end
--
function c1150027.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,1150029,RESET_PHASE+PHASE_END,0,1)
end
--
function c1150027.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,1150027,RESET_CHAIN,0,1)
end
function c1150027.con2_3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1150027)>0
end
function c1150027.op2_3(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,1150027)
	Duel.ResetFlagEffect(tp,1150027)
	Duel.Recover(tp,n*100,REASON_EFFECT)
end
--
function c1150027.cfilter3(c)
	return c:IsAbleToDeckAsCost() and not c:IsRace(RACE_PLANT)
end
function c1150027.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150027.cfilter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c1150027.cfilter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
--
function c1150027.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,1150029)>0
end
--
function c1150027.tfilter3(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function c1150027.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1150027.tfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1150027.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c1150027.tfilter4,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
--
function c1150027.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=1
end
--
function c1150027.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
--
function c1150027.ofilter4(c,opt)
	if opt==0 then return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
	else 
		if opt==1 then return c:IsAbleToGrave() and c:IsType(TYPE_SPELL)
		else 
			if opt==2 then return c:IsAbleToGrave() and c:IsType(TYPE_TRAP)
			else return false
			end
		end
	end
end
function c1150027.ofilter4_1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1150027.ofilter4_2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c1150027.ofilter4_3(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c1150027.op4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 then
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0,nil)
		local tc=g:RandomSelect(1-tp,1):GetFirst()
		Duel.ConfirmCards(tp,tc)
		Duel.ShuffleHand(1-tp)
		local opt=e:GetLabel()
		if (opt==0 and tc:IsType(TYPE_MONSTER)) or (opt==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=Duel.SelectMatchingCard(1-tp,c1150027.ofilter4,1-tp,LOCATION_HAND,0,1,1,nil,opt)
			if sg:GetCount()>0 then
				Duel.SendtoGrave(sg,REASON_EFFECT)
				Duel.Recover(1-tp,800,REASON_EFFECT)
			end
		else
			if Duel.Recover(tp,300,REASON_EFFECT)>0 then
				if opt==0 and Duel.GetMatchingGroup(c1150027.ofilter4_1,1-tp,LOCATION_GRAVE,0,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(1150027,2)) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
					local gn=Duel.SelectMatchingCard(1-tp,c1150027.ofilter4_1,1-tp,LOCATION_GRAVE,0,1,1,nil)
					if gn:GetCount()>0 then
						Duel.SendtoHand(gn,nil,REASON_EFFECT)
						Duel.ConfirmCards(tp,gn)
					end  
				else 
					if opt==1 and Duel.GetMatchingGroup(c1150027.ofilter4_2,1-tp,LOCATION_GRAVE,0,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(1150027,2)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
						local gn=Duel.SelectMatchingCard(1-tp,c1150027.ofilter4_2,1-tp,LOCATION_GRAVE,0,1,1,nil)
						if gn:GetCount()>0 then
							Duel.SendtoHand(gn,nil,REASON_EFFECT)
							Duel.ConfirmCards(tp,gn)
						end  
					else 
						if opt==2 and Duel.GetMatchingGroup(c1150027.ofilter4_3,1-tp,LOCATION_GRAVE,0,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(1150027,2)) then
							Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
							local gn=Duel.SelectMatchingCard(1-tp,c1150027.ofilter4_3,1-tp,LOCATION_GRAVE,0,1,1,nil)
							if gn:GetCount()>0 then
								Duel.SendtoHand(gn,nil,REASON_EFFECT)
								Duel.ConfirmCards(tp,gn)
							end
						end
					end
				end
			end
		end
	end
end


