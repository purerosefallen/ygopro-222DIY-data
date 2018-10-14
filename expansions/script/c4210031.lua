--猫耳天堂-偶像红豆
function c4210031.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4210031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(SUMMON_TYPE_RITUAL)
	e1:SetCondition(c4210031.spcon)
	e1:SetTarget(c4210031.sptg)
	e1:SetOperation(c4210031.spop)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4210031,2))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c4210031.condition)
	e2:SetTarget(c4210031.target)
	e2:SetOperation(c4210031.operation)
	c:RegisterEffect(e2)
	--return to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4210031,3))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_RELEASE)
	e3:SetCountLimit(1,4210031)
	e3:SetTarget(c4210031.rttg)
	e3:SetOperation(c4210031.rtop)
	c:RegisterEffect(e3)
	local e4 = e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_DECK) end)
	c:RegisterEffect(e4)
end
function c4210031.filter(c,e,tp,m1,m2,ft)
	local mg=m1:Filter(Card.IsReleasable,c)
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumEqual(Card.GetLevel,6,1,99,c)
	else
		return ft>-1 and mg:IsExists(c4210031.mfilterf,1,nil,tp,mg,c)
	end
end
function c4210031.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetLevel,9,0,99,rc)
	else return false end
end
function c4210031.relfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c4210031.repfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_BEASTWARRIOR) and c:IsAbleToDeck() 
end
function c4210031.spcon(e,c)	
	if c==nil then return true end
		local mg1=Duel.GetMatchingGroup(c4210031.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
		local mg2=Duel.GetMatchingGroup(c4210031.repfilter,tp,LOCATION_REMOVED,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)		
		return Duel.IsExistingMatchingCard(c4210031.filter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210028)
			and (e:GetHandler():IsLocation(LOCATION_HAND) or (e:GetHandler():IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024)))
end
function c4210031.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==1 then return true end	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,e:GetHandler():GetLocation())
end
function c4210031.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,Card.IsCode,1,1,REASON_COST+REASON_DISCARD,nil,4210028)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local showcard = Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,4210024)
		Duel.ConfirmCards(1-tp,showcard)
		Duel.RaiseEvent(showcard,0x1420042a,e,REASON_COST,tp,0,0)
		Duel.ShuffleHand(tp)
	end
	local mg1=Duel.GetMatchingGroup(c4210031.relfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,e:GetHandler())
	local mg2=Duel.GetMatchingGroup(c4210031.repfilter,tp,LOCATION_REMOVED,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=e:GetHandler()
	if tc then
		local mg=mg1:Filter(Card.IsReleasable,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil)
		end
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumEqual(tp,Card.GetLevel,6,1,99,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c4210031.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumEqual(tp,Card.GetLevel,6,0,99,tc)
			mat:Merge(mat2)
		end				
		local rm= mat:Filter(Card.IsLocation,tp,LOCATION_REMOVED)
		Duel.SendtoDeck(rm,nil,0,REASON_COST)
		Duel.Release(mat,REASON_COST+REASON_RELEASE)
		local code = tc:GetCode()
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210010,1))
		tc:RegisterFlagEffect(4210010,RESET_EVENT+0xcff0000,0,0)
		tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,1))
		tc:RegisterFlagEffect(code,RESET_EVENT+0xcff0000,0,0)
	end
end

function c4210031.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c4210031.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c4210031.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then Duel.IsExistingMatchingCard(c4210031.cdfilter,tp,LOCATION_REMOVED,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local hg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD)
	Duel.ShuffleHand(1-tp)
	local tc=hg:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.Damage(1-tp,tc:GetLevel()*200,REASON_EFFECT)
	end
end
function c4210031.cdfilter(c) 
	return c:IsSetCard(0xa2f) and c:IsFaceup() 
end
function c4210031.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4210031.cdfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c4210031.rtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c4210031.cdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if sg:GetCount()>0 then
		if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)~=0 
			and Duel.IsExistingMatchingCard(c4210031.cdfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,4210024) then
			if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4210031,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
				local showcard = Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_HAND,0,1,1,nil,4210024)
				Duel.ConfirmCards(1-tp,showcard)
				Duel.RaiseEvent(showcard,0x1420042a,e,REASON_COST,tp,0,0)
				Duel.ShuffleHand(tp)
				
				local tc = Duel.GetMatchingGroup(c4210031.cdfilter,tp,LOCATION_MZONE,0,nil):Select(tp,1,1,nil):GetFirst()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DIRECT_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)				
				--atkdown
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_ATTACK_FINAL)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e2:SetRange(LOCATION_MZONE)
				e2:SetCondition(c4210031.atkcon)
				e2:SetValue(c4210031.atkval)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
				tc:RegisterFlagEffect(0,RESET_EVENT+0xcff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4210031,5))			
			end				
		end
	end
end
function c4210031.atkcon(e)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL then return false end
	local c=e:GetHandler()
	return c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)==1
end
function c4210031.atkval(e,c)
	return c:GetAttack()/2
end