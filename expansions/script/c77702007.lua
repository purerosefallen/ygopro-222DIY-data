local m=77702007
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetCode(EFFECT_MAP_OF_HEAVEN)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetFlagEffect(m)>0
	end)
	e2:SetValue(1)
	c:RegisterEffect(e2)]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTargetRange(LOCATION_EXTRA,0)
		e2:SetCode(EFFECT_MAP_OF_HEAVEN)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		--[[local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_TO_HAND)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_DECK))
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)]]
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_MATERIAL_CHECK)
		e3:SetLabelObject(e2)
		e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		e3:SetTargetRange(0xff,0xff)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetTarget(function(e,c)
			return bit.band(c:GetType(),0x81)==0x81
		end)
		e3:SetValue(function(e,c)
			--Debug.Message(0)
			if c:GetMaterial():IsExists(function(c)
				if not c:IsLocation(LOCATION_EXTRA) then return false end
				local eset={c:IsHasEffect(EFFECT_MAP_OF_HEAVEN)}
				for _,te in ipairs(eset) do
					if te==e:GetLabelObject() then return true end
				end
				return false
			end,1,nil) then
				--Debug.Message(1)
				local ex=Effect.CreateEffect(e:GetHandler())
				ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ex:SetCode(EVENT_SPSUMMON_SUCCESS)
				ex:SetLabelObject(e:GetLabelObject())
				ex:SetReset(RESET_PHASE+PHASE_END)
				ex:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					return eg:IsContains(c)
				end)
				ex:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
					e:GetLabelObject():Reset()
					e:Reset()
				end)
				Duel.RegisterEffect(ex,tp)
				e:Reset()
			end
		end)
		Duel.RegisterEffect(e3,tp)
	end)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 and e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function cm.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_RITUAL) and c:IsLevelAbove(7)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local res=0
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetDecktopGroup(tp,5):Filter(cm.filter,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		res=Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
	--[[if res>0 then
		Duel.BreakEffect()
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(m,0x1fe1000,0,1)
	end]]
end
