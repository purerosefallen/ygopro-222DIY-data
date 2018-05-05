--第六天魔王 织田信长
function c5013666.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit() 
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c5013666.efilter)
	c:RegisterEffect(e1)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5013666,7))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(3)
	e3:SetHintTiming(0,0x1e0)
	e3:SetTarget(c5013666.destg)
	e3:SetOperation(c5013666.desop)
	c:RegisterEffect(e3)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c5013666.val)
	c:RegisterEffect(e2)
	--Def
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
function c5013666.val(e,c)
	return -1*(Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)*666)
end
function c5013666.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,666)
end
function c5013666.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	   local fid=tc:GetFieldID()
	   math.randomseed(fid)
	   local hint=math.random(0,6)
	   local seq=tc:GetSequence()
	   if tc:IsControler(tp) and tc:IsLocation(LOCATION_SZONE) then
		  if seq==5 then seq=7
		  elseif seq==0 then seq=8
		  elseif seq==1 then seq=9
		  elseif seq==2 then seq=10
		  elseif seq==3 then seq=11
		  else seq=12
		  end
	   end
	   if tc:IsControler(1-tp) then seq=seq+16 end	   
	   Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(5013666,hint))
	   Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(5013666,hint))
	   tc:RegisterFlagEffect(5013666,RESET_EVENT+0x1fc0000,0,0)
	   if tc:GetFlagEffect(5013666)==3 then
		  Duel.SendtoGrave(tc,REASON_RULE)
		  return
	   end
	   if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.Damage(1-tp,666,REASON_EFFECT)~=0 then
		  local e1=Effect.CreateEffect(e:GetHandler())
		  e1:SetType(EFFECT_TYPE_FIELD)
		  e1:SetCode(EFFECT_DISABLE_FIELD)
		  e1:SetLabel(seq)
		  e1:SetOperation(c5013666.disop)
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  Duel.RegisterEffect(e1,tp)   
	   end
	end
end
function c5013666.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c5013666.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end
