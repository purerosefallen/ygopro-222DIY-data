--莉蒂与苏尔的工作室
function c4212318.initial_effect(c)
	c:SetUniqueOnField(1,0,4212318)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetOperation(c4212318.activate)
	c:RegisterEffect(e2)
	--Activate(effect)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4212318,3))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c4212318.con)
	e3:SetTarget(c4212318.tg)
	e3:SetOperation(c4212318.op)
	c:RegisterEffect(e3)
end
function c4212318.mfilter(c) 
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c4212318.cfilter(c) 
	return c:IsSetCard(0x2a5) and c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c4212318.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c4212318.cfilter,tp,LOCATION_DECK,0,1,e:GetHandler()) then
		if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212318,0)) then
			local c=e:GetHandler()
			if c:IsFaceup() then
				local sg = Duel.GetMatchingGroup(function(c,zone) 
					return c:GetSequence() == zone 
						or (math.ceil(c:GetSequence())==5 and zone==1 ) 
						or (math.ceil(c:GetSequence())==6 and zone==3 ) 
					end,tp,LOCATION_MZONE,0,nil,math.ceil(c:GetSequence()))
				local sg2 = Duel.GetMatchingGroup(function(c,zone) 
					return c:GetSequence() == 4-zone 
						or (math.ceil(c:GetSequence())==6 and zone==1 ) 
						or (math.ceil(c:GetSequence())==5 and zone==3 ) 
					end,tp,0,LOCATION_MZONE,nil,math.ceil(c:GetSequence()))
				sg:Merge(sg2)
				if sg:GetCount()>0 then	 
					local tc = sg:GetFirst()
					while tc do 
						local e1=Effect.CreateEffect(c)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
						e1:SetRange(LOCATION_MZONE)
						e1:SetReset(RESET_EVENT+0xff0000)
						e1:SetCode(EFFECT_SET_BASE_ATTACK)
						e1:SetValue(1000)
						tc:RegisterEffect(e1)
						tc = sg:GetNext()
					end				 
				end
			end
		end
		if Duel.GetMatchingGroupCount(c4212318.mfilter,tp,LOCATION_SZONE,0,nil)>=3 
			and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),TYPE_MONSTER) then
			if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212318,1)) then
				local tc = Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),TYPE_MONSTER)
				if tc:GetCount()>0 then
					Duel.Destroy(tc,REASON_EFFECT)
				end
			end
		end
	end
end
function c4212318.cdfilter(c) 
	return (c:IsCode(4212314) or c:IsCode(4212315)) and c:IsAbleToGrave()
end
function c4212318.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c4212318.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():CheckUniqueOnField(tp) and not e:GetHandler():IsForbidden() 
	end 
end
function c4212318.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		if Duel.IsExistingMatchingCard(c4212318.cdfilter,tp,LOCATION_DECK,0,1,nil) then
			if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(4212318,2)) then
				local tc = Duel.SelectMatchingCard(tp,c4212318.cdfilter,tp,LOCATION_DECK,0,1,1,nil)
				if tc then 
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end
		end
	end
end