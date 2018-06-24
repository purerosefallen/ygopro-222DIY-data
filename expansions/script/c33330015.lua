--深界的黑暗面 雷古
function c33330015.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--r d
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33330015,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c33330015.destg)
	e2:SetOperation(c33330015.desop)
	c:RegisterEffect(e2)	
	--reflect battle dam
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)  
	--atk up
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetCondition(c33330015.atkcon)
	e6:SetTarget(c33330015.atktg)
	e6:SetOperation(c33330015.atkop)
	c:RegisterEffect(e6)
end
function c33330015.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
end
function c33330015.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_FIELD)
		return ct>0 and c:GetFlagEffect(33330015)==0
	end
	c:RegisterFlagEffect(33330015,RESET_CHAIN,0,1)
end
function c33330015.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_FIELD)
	if c:IsRelateToEffect(e) and c:IsFaceup() and ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESET_CHAIN)
		e1:SetValue(ct*1500)
		c:RegisterEffect(e1)
	end
end
function c33330015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_FZONE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function c33330015.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 then
	   local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	   if g:GetCount()<=0 then return end
	   if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		  local fid=c:GetFieldID()
		  local rct=1
		  local og=Duel.GetOperatedGroup()
		  local oc=og:GetFirst()
		  while oc do
			  oc:RegisterFlagEffect(33330015,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		  oc=og:GetNext()
		  end
		  og:KeepAlive()
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		  e1:SetCode(EVENT_PHASE+PHASE_END)
		  e1:SetCountLimit(1)
		  e1:SetLabel(fid)
		  e1:SetLabelObject(og)
		  e1:SetCondition(c33330015.retcon)
		  e1:SetOperation(c33330015.retop)
		  e1:SetReset(RESET_PHASE+PHASE_END)
		  e1:SetValue(Duel.GetTurnCount())
		  Duel.RegisterEffect(e1,tp)
	   end
	end
end
function c33330015.retfilter(c,fid)
	return c:GetFlagEffectLabel(33330015)==fid
end
function c33330015.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount()==e:GetValue() then return false end
	local g=e:GetLabelObject()
	if not g:IsExists(c33330015.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c33330015.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c33330015.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local ct,tg=Duel.GetLocationCount(tp,LOCATION_MZONE),Group.CreateGroup()
	if sg:GetCount()>ct and ct>0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	   tg=sg:Select(tp,ct1,ct1,nil)
	end
	sg:Sub(tg)
	local tc=tg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
	tc=tg:GetNext()
	end
	tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
	tc=sg:GetNext()
	end
end

