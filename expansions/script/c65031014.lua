--独我的律歌者
function c65031014.initial_effect(c)
	--spsummon!
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1)
	e0:SetTarget(c65031014.tg)
	e0:SetOperation(c65031014.op)
	c:RegisterEffect(e0)
	--chain!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65031014.chcon)
	e1:SetTarget(c65031014.chtg)
	e1:SetOperation(c65031014.chop)
	c:RegisterEffect(e1)
	--sing!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65031014.spcon)
	e2:SetTarget(c65031014.sptg)
	e2:SetOperation(c65031014.spop)
	c:RegisterEffect(e2)
end
function c65031014.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c65031014.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsCanBeSpecialSummoned(e,1,tp,false,false,POS_FACEUP,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,1,tp,1-tp,false,false,POS_FACEUP)
	end
end
function c65031014.chcon(e,tp,eg,ep,ev,re,r,rp)
	return not re:GetHandler():IsCode(65031014) and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c65031014.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,0)
end
function c65031014.chfil(c)
	return c:IsSetCard(0xada1) and c:IsType(TYPE_COUNTER) and c:IsSSetable()
end
function c65031014.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(1-tp,c65031014.chfil,1-tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SSet(1-tp,g)~=0 then
		Duel.ConfirmCards(tp,g)
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		end
		end
	end
end
function c65031014.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c65031014.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,0,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,500)
end
function c65031014.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardHand(tp,Card.IsAbleToGrave,1,1,REASON_EFFECT,nil)~=0 then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
			if g:GetCount()>0 then
				if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
					local tc=g:GetFirst()
					if Duel.Damage(tp,500,REASON_EFFECT)~=0 then
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_DISABLE_EFFECT)
						e2:SetValue(RESET_TURN_SET)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
						tc:RegisterEffect(e2)
					end
				end
			end
		end
	end
end